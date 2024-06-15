from flask import render_template, redirect, url_for, flash, request, Blueprint, abort, send_from_directory, send_file
from werkzeug.utils import secure_filename
from datetime import datetime
from sqlalchemy import and_, func
import os
import hashlib
import markdown
from models import Book, Genre, BookGenre, Cover, Review, User, Visit, db
from flask_login import login_required, current_user
from bleach import clean as bleach_clean
import mimetypes
from auth import check_rights
import csv
from io import BytesIO, StringIO

bp_book = Blueprint('book', __name__, url_prefix='/book')

UPLOAD_FOLDER = os.path.join(os.path.dirname(os.path.abspath(__file__)), 'media', 'covers')


from sqlalchemy import func

@bp_book.route('/show/<int:book_id>')
def show(book_id):
    try:
        book_query = db.session.query(
            Book.id,
            Book.title,
            Book.description,
            Book.year,
            Book.publisher,
            Book.author,
            Book.pages,
            Book.cover_id,
            func.group_concat(Genre.name).label('genres'),
            func.coalesce(func.avg(Review.rating), 0).label('avg_rating'),
            func.count(Review.id).label('review_count')
        ).outerjoin(BookGenre, Book.id == BookGenre.book_id)\
        .outerjoin(Genre, BookGenre.genre_id == Genre.id)\
        .outerjoin(Review, Review.book_id == Book.id)\
        .filter(Book.id == book_id).group_by(Book.id).first()

        if book_query is None:
            abort(404)

        cover_id = book_query.cover_id
        cover_img = Cover.query.filter_by(id=cover_id).first()
        cover_img = cover_img.file_name if cover_img else None

        reviews = db.session.query(
            Review.rating,
            Review.text,
            Review.user_id,
            User.login
        ).join(User, Review.user_id == User.id)\
        .filter(Review.book_id == book_id).all()

        description_html = markdown.markdown(book_query.description)

        user_id = current_user.id if current_user.is_authenticated else None
        now = datetime.utcnow()
        start_of_day = now.replace(hour=0, minute=0, second=0, microsecond=0)
        visit_count = db.session.query(func.count(Visit.id)).filter(
            and_(
                Visit.user_id == user_id,
                Visit.book_id == book_id,
                Visit.visit_time >= start_of_day
            )
        ).scalar()
        
        if visit_count < 10:
            visit = Visit(user_id=user_id, book_id=book_id, visit_time=now)
            db.session.add(visit)
            db.session.commit()

        return render_template('book/show.html', book=book_query, description_html=description_html, reviews=reviews, cover_img=cover_img)
    except Exception as e:
        flash('Произошла ошибка при загрузке данных книги: {}'.format(str(e)), 'danger')
        return render_template('book/show.html', book=None, description_html='', reviews=[], cover_img=None)




@bp_book.route('/add_book', methods=['GET', 'POST'])
@login_required
@check_rights('add')
def add():
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
        cover_id = None

        if cover:
            filename = secure_filename(cover.filename)
            file_data = cover.read()
            file_hash = hashlib.md5(file_data).hexdigest()
            mime_type = mimetypes.guess_type(filename)[0] or 'application/octet-stream'
            
            existing_cover = Cover.query.filter_by(md5_hash=file_hash).first()
            if existing_cover:
                cover_id = existing_cover.id
            else:
                new_cover = Cover(file_name=filename, mime_type=mime_type, md5_hash=file_hash)
                db.session.add(new_cover)
                db.session.commit()
                cover_id = new_cover.id

                cover_path = os.path.join(UPLOAD_FOLDER, f"{cover_id}_{filename}")
                with open(cover_path, 'wb') as f:
                    f.write(file_data)
        
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
@check_rights('edit')
def edit(book_id):
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
    
@bp_book.route('/write_review/<int:book_id>', methods=['GET', 'POST'])
@login_required
def write_review(book_id):
    book = Book.query.get_or_404(book_id)

    if request.method == 'POST':
        rating = request.form['rating']
        text = bleach_clean(request.form['text'])

        existing_review = Review.query.filter_by(book_id=book_id, user_id=current_user.id).first()
        if existing_review:
            flash('Вы уже писали рецензию на эту книгу.', 'danger')
            return redirect(url_for('book.show', book_id=book_id))

        new_review = Review(rating=rating, text=text, book_id=book_id, user_id=current_user.id)
        try:
            db.session.add(new_review)
            db.session.commit()
            flash('Рецензия успешно добавлена.', 'success')
            return redirect(url_for('book.show', book_id=book_id))
        except Exception as e:
            db.session.rollback()
            flash('Произошла ошибка при добавлении рецензии. Попробуйте еще раз.', 'danger')
            return render_template('book/write_review.html', book=book, errors=[str(e)])

    return render_template('book/write_review.html', book=book, errors=[])


@bp_book.route('/delete/<int:book_id>', methods=['POST'])
@login_required
@check_rights('delete')
def delete(book_id):
    book = Book.query.get_or_404(book_id)

    try:
        # Удаление связанных жанров
        BookGenre.query.filter_by(book_id=book.id).delete()

        # Удаление связанных рецензий
        Review.query.filter_by(book_id=book.id).delete()

        # Удаление связанных посещений
        Visit.query.filter_by(book_id=book.id).delete()

        # Удаление обложки
        if book.cover_id:
            other_books_with_same_cover = Book.query.filter(Book.cover_id == book.cover_id, Book.id != book.id).count()
            if other_books_with_same_cover == 0:
                cover = Cover.query.get(book.cover_id)
                if cover:
                    # Удаление файла обложки из файловой системы
                    cover_path = os.path.join(UPLOAD_FOLDER, cover.file_name)
                    if os.path.exists(cover_path):
                        os.remove(cover_path)
                    # Удаление записи обложки из базы данных
                    db.session.delete(cover)

        # Удаление книги
        db.session.delete(book)
        db.session.commit()

        flash('Книга успешно удалена', 'success')
        return redirect(url_for('index'))
    except Exception as e:
        db.session.rollback()
        flash('При удалении книги возникла ошибка: {}'.format(str(e)), 'danger')
        return redirect(url_for('index'))

    

@bp_book.route('/admin/stats')
@login_required
@check_rights('visit')
def admin_stats():
    return redirect(url_for('book.user_actions'))


@bp_book.route('/admin/user_actions')
@login_required
@check_rights('visit')
def user_actions():
    PER_PAGE = 10
    page = request.args.get('page', 1, type=int)

    user_actions_query = db.session.query(
        Visit.id,
        Visit.visit_time,
        db.case(
            (User.id.is_(None), 'Неаутентифицированный пользователь'),
            else_=db.func.concat(User.first_name, ' ', User.last_name, ' ', User.middle_name)
        ).label('full_name'),
        Book.title
    ).join(Book, Visit.book_id == Book.id)\
    .outerjoin(User, Visit.user_id == User.id)\
    .order_by(Visit.visit_time.desc())

    user_actions = user_actions_query.paginate(page=page, per_page=PER_PAGE, error_out=False)

    start = (page - 1) * PER_PAGE

    return render_template('admin/user_actions.html', 
                           user_actions=user_actions.items, 
                           pages=user_actions.pages,
                           current_page=page,
                           start=start,
                           enumerate=enumerate)


@bp_book.route('/admin/book_stats')
@login_required
@check_rights('visit')
def book_stats():
    PER_PAGE = 10
    page = request.args.get('page', 1, type=int)
    date_from = request.args.get('date_from')
    date_to = request.args.get('date_to')

    try:
        if date_from:
            date_from = datetime.strptime(date_from, '%Y-%m-%d')
        if date_to:
            date_to = datetime.strptime(date_to, '%Y-%m-%d')
    except ValueError:
        date_from = None
        date_to = None

    book_stats_query = db.session.query(
        Book.id,
        Book.title,
        func.count(Visit.id).label('visit_count')
    ).join(Visit)\
    .group_by(Book.id)\
    .order_by(func.count(Visit.id).desc())

    if date_from:
        book_stats_query = book_stats_query.filter(Visit.visit_time >= date_from)
    if date_to:
        book_stats_query = book_stats_query.filter(Visit.visit_time <= date_to)

    book_stats = book_stats_query.paginate(page=page, per_page=PER_PAGE, error_out=False)

    start = (page - 1) * PER_PAGE

    return render_template('admin/book_stats.html', 
                           book_stats=book_stats.items, 
                           pages=book_stats.pages,
                           current_page=page,
                           start=start,
                           date_from=request.args.get('date_from', ''),
                           date_to=request.args.get('date_to', ''),
                           enumerate=enumerate)



@bp_book.route('/export_user_action_csv')
@check_rights('visit')
def export_user_action_csv():
    try:
        user_activities = db.session.query(Visit).all()
        
        date_str = datetime.now().strftime("%Y-%m-%d")
        filename = f"user_actions_{date_str}.csv"
        
        si = StringIO()
        writer = csv.writer(si)
        
        writer.writerow(["Visit ID", "User", "Book ID", "Visit Time"])
        
        for activity in user_activities:
            user_display = f"{activity.user.id}" if activity.user else "Unauthorized user"
            writer.writerow([activity.id, user_display, activity.book_id, activity.visit_time])
        
        response_data = BytesIO(si.getvalue().encode('utf-8'))
        
        response = send_file(
            response_data,
            mimetype="text/csv",
            as_attachment=True,
            download_name=filename
        )
        return response
    except Exception as e:
        flash(f'Ошибка при экспорте данных: {str(e)}', 'danger')
        return redirect(url_for('book.admin_stats'))


@bp_book.route('/export_book_stats_csv')
@check_rights('visit')
def export_book_stats_csv():
    try:
        book_stats = db.session.query(
            Book.id, 
            Book.title, 
            func.count(Visit.id).label('view_count')
        ).outerjoin(Visit, Visit.book_id == Book.id)\
         .group_by(Book.id).all()
        
        date_str = datetime.now().strftime("%Y-%m-%d")
        filename = f"book_stats_{date_str}.csv"
        

        si = StringIO()
        writer = csv.writer(si)

        
        writer.writerow(["Book ID", "Title", "View Count"])
        
        for stat in book_stats:
           writer.writerow([stat.id, stat.title, stat.view_count])

        response_data = BytesIO(si.getvalue().encode('utf-8'))

        response = send_file(
            response_data,
            mimetype="text/csv",
            as_attachment=True,
            download_name=filename
        )
        return response
    except Exception as e:
        flash(f'Ошибка при экспорте данных: {str(e)}', 'danger')
        return redirect(url_for('book.admin_stats'))


@bp_book.route('/media/covers/<cover_id>')
def image(cover_id):
    cover = Cover.query.get(cover_id)
    if cover is None:
        abort(404)
    return send_from_directory(UPLOAD_FOLDER, cover.file_name)
