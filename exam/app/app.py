from flask import Flask, render_template, abort, send_from_directory, flash
from flask_migrate import Migrate
from models import Cover, Book, Review, Genre, BookGenre, db, Role, Visit
from auth import bp_auth, init_login_manager
from book import bp_book
from datetime import datetime, timedelta
import math
from sqlalchemy import func
from sqlalchemy.exc import SQLAlchemyError
from flask_login import current_user

app = Flask(__name__)
application = app

app.config.from_pyfile('config.py')

db.init_app(app)
migrate = Migrate(app, db)

init_login_manager(app)

app.register_blueprint(bp_auth)
app.register_blueprint(bp_book)

@app.errorhandler(SQLAlchemyError)
def handle_sqlalchemy_error(err):
    error_msg = ('Возникла ошибка при подключении к базе данных. '
                 'Повторите попытку позже.')
    return f'{error_msg} (Подробнее: {err})', 500

def get_user_roles():
    if current_user.is_authenticated:
        return [current_user.role_id]
    return []

@app.route('/')
@app.route('/page/<int:page>')
def index(page=1):
    PER_PAGE = 10  # Количество книг на одной странице
    try:
        # Запрос для получения общего количества книг
        total_books = db.session.query(func.count(Book.id)).scalar()

        # Вычисление общего количества страниц
        total_pages = math.ceil(total_books / PER_PAGE)

        # Запрос для получения списка книг с учетом пагинации
        books = db.session.query(
            Book.id,
            Book.title,
            Book.description,
            Book.year,
            Book.publisher,
            Book.author,
            Book.pages,
            Book.cover_id,
            func.avg(Review.rating).label('avg_rating'),
            func.count(Review.id).label('review_count'),
            func.group_concat(Genre.name).label('genres')
        ).outerjoin(Review, Book.id == Review.book_id)\
        .outerjoin(BookGenre, Book.id == BookGenre.book_id)\
        .outerjoin(Genre, BookGenre.genre_id == Genre.id)\
        .group_by(Book.id)\
        .order_by(Book.year.desc())\
        .limit(PER_PAGE).offset((page - 1) * PER_PAGE).all()

        popular_books = db.session.query(
            Book.id,
            Book.title,
            Book.cover_id,
            func.count(Visit.id).label('visit_count')
        ).join(Visit).filter(
            Visit.visit_time >= datetime.utcnow() - timedelta(days=90)
        ).group_by(Book.id).order_by(func.count(Visit.id).desc()).limit(5).all()

        # Проверяем, аутентифицирован ли пользователь
        if current_user.is_authenticated:
            recent_books = db.session.query(
                Book.id,
                Book.title,
                Book.cover_id
            ).join(Visit).filter(
                Visit.user_id == current_user.id
            ).order_by(Visit.visit_time.desc()).limit(5).all()
        else:
            recent_books = db.session.query(
                Book.id,
                Book.title,
                Book.cover_id
            ).join(Visit).order_by(Visit.visit_time.desc()).limit(5).all()

        user_roles = get_user_roles()

        return render_template('index.html', books=books, page=page, total_pages=total_pages, user_roles=user_roles, popular_books=popular_books, recent_books=recent_books)
    except Exception as e:
        flash('Произошла ошибка при загрузке книг: {}'.format(str(e)), 'danger')
        return render_template('index.html', books=[], page=1, total_pages=1)


@app.route('/media/covers/<cover_id>')
def image(cover_id):
    cover = Cover.query.get(cover_id)
    if cover is None:
        abort(404)
    return send_from_directory(app.config['UPLOAD_FOLDER'], cover.file_name)

if __name__ == '__main__':
    app.run(debug=True)


