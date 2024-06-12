from flask import render_template, redirect, url_for, flash, request, Blueprint, abort, send_from_directory
from werkzeug.utils import secure_filename
from sqlalchemy import func
import os
import hashlib
import markdown
from models import Book, Genre, BookGenre, Cover, Review, User, db
from flask_login import login_required, current_user
from bleach import clean as bleach_clean
from check_rights import admin_required

bp_book = Blueprint('book', __name__, url_prefix='/book')

UPLOAD_FOLDER = os.path.join(os.path.dirname(os.path.abspath(__file__)), 'media', 'covers')

@bp_book.route('/show/<int:book_id>')
def show(book_id):
    try:
        # Получаем книгу по ID
        book = db.session.query(
            Book.id,
            Book.title,
            Book.description,
            Book.year,
            Book.publisher,
            Book.author,
            Book.pages,
            Book.cover_id,
            func.group_concat(Genre.name).label('genres')
        ).outerjoin(BookGenre, Book.id == BookGenre.book_id)\
        .outerjoin(Genre, BookGenre.genre_id == Genre.id)\
        .filter(Book.id == book_id).group_by(Book.id).first()

        if book is None:
            abort(404)

        cover_id = book.cover_id
        cover_img = Cover.query.filter_by(id=cover_id).first()
        cover_img = cover_img.file_name if cover_img else None

        # Получаем рецензии для книги
        reviews = db.session.query(
            Review.rating,
            Review.text,
            Review.user_id,
            User.login
        ).join(User, Review.user_id == User.id)\
        .filter(Review.book_id == book_id).all()

        # Конвертируем описание книги из Markdown в HTML
        description_html = markdown.markdown(book.description)

        return render_template('book/show.html', book=book, description_html=description_html, reviews=reviews, cover_img=cover_img)
    except Exception as e:
        flash('Произошла ошибка при загрузке данных книги: {}'.format(str(e)), 'danger')
        return render_template('book/show.html', book=None, description_html='', reviews=[], cover_img=None)

@bp_book.route('/add_book', methods=['GET', 'POST'])
@admin_required
@login_required
def add():
    if not current_user.can('add'):
        abort(403)

    if request.method == 'POST':
        errors = []
        title = request.form['title']
        author = request.form['author']
        year = request.form['year']
        publisher = request.form['publisher']
        pages = request.form['pages']
        description = bleach_clean(request.form['description'])
        genres = request.form.getlist('genres')
        
        cover = request.files['cover']
        if cover:
            filename = secure_filename(cover.filename)
            cover_path = os.path.join(UPLOAD_FOLDER, filename)
            cover.save(cover_path)
            with open(cover_path, 'rb') as f:
                file_hash = hashlib.md5(f.read()).hexdigest()
            
            existing_cover = Cover.query.filter_by(md5_hash=file_hash).first()
            if existing_cover:
                cover_id = existing_cover.id
            else:
                new_cover = Cover(file_name=filename, md5_hash=file_hash)
                db.session.add(new_cover)
                db.session.commit()
                cover_id = new_cover.id
        else:
            cover_id = None

        try:
            new_book = Book(title=title, author=author, year=year, publisher=publisher, pages=pages, description=description, cover_id=cover_id)
            db.session.add(new_book)
            db.session.commit()

            for genre_id in genres:
                new_book_genre = BookGenre(book_id=new_book.id, genre_id=genre_id)
                db.session.add(new_book_genre)
            
            db.session.commit()
            flash('Книга успешно добавлена', 'success')
            return redirect(url_for('book.show', book_id=new_book.id))
        except Exception as e:
            db.session.rollback()
            errors.append('При сохранении данных возникла ошибка. Проверьте корректность введённых данных.')
            return render_template('book/add_book.html', genres=Genre.query.all(), errors=errors)
    return render_template('book/add_book.html', genres=Genre.query.all(), errors=[])

@bp_book.route('/edit/<int:book_id>', methods=['GET', 'POST'])
@login_required
def edit(book_id):
    if not current_user.can('edit'):
        abort(403)

    book = Book.query.get_or_404(book_id)

    if request.method == 'POST':
        errors = []
        book.title = request.form['title']
        book.author = request.form['author']
        book.year = request.form['year']
        book.publisher = request.form['publisher']
        book.pages = request.form['pages']
        book.description = bleach_clean(request.form['description'])
        genres = request.form.getlist('genres')
        
        try:
            db.session.commit()
            BookGenre.query.filter_by(book_id=book.id).delete()
            for genre_id in genres:
                new_book_genre = BookGenre(book_id=book.id, genre_id=genre_id)
                db.session.add(new_book_genre)
            
            db.session.commit()
            flash('Книга успешно отредактирована', 'success')
            return redirect(url_for('book.show', book_id=book.id))
        except Exception as e:
            db.session.rollback()
            errors.append('При сохранении данных возникла ошибка. Проверьте корректность введённых данных.')
            return render_template('book/edit.html', book=book, genres=Genre.query.all(), errors=errors)

    return render_template('book/edit.html', book=book, genres=Genre.query.all(), errors=[])

@bp_book.route('/delete/<int:book_id>', methods=['POST'])
@admin_required
@login_required
def delete(book_id):
    if not current_user.can('delete'):
        abort(403)

    book = Book.query.get_or_404(book_id)

    try:
        db.session.delete(book)
        db.session.commit()
        flash('Книга успешно удалена', 'success')
        return redirect(url_for('index'))
    except Exception as e:
        db.session.rollback()
        flash('При удалении книги возникла ошибка', 'danger')
        return redirect(url_for('book.show', book_id=book_id))


@bp_book.route('/media/covers/<cover_id>')
def image(cover_id):
    cover = Cover.query.get(cover_id)
    if cover is None:
        abort(404)
    return send_from_directory(UPLOAD_FOLDER, cover.file_name)
