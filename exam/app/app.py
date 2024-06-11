from flask import Flask, render_template, abort, send_from_directory, flash
from flask_migrate import Migrate
from models import Cover, Book, Review, Genre, BookGenre, db
from auth import bp_auth as auth_bp, init_login_manager
import math
from sqlalchemy import func
from sqlalchemy.exc import SQLAlchemyError


app = Flask(__name__)
application = app

app.config.from_pyfile('config.py')

db.init_app(app)
migrate = Migrate(app, db)

init_login_manager(app)


app.register_blueprint(auth_bp)

@app.errorhandler(SQLAlchemyError)
def handle_sqlalchemy_error(err):
    error_msg = ('Возникла ошибка при подключении к базе данных. '
                 'Повторите попытку позже.')
    return f'{error_msg} (Подробнее: {err})', 500

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
            Book.publication_year.label('year'),
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
        .order_by(Book.publication_year.desc())\
        .limit(PER_PAGE).offset((page - 1) * PER_PAGE).all()

        return render_template('index.html', books=books, page=page, total_pages=total_pages)
    except Exception as e:
        flash('Произошла ошибка при загрузке книг: {}'.format(str(e)), 'danger')
        return render_template('index.html', books=[], page=1, total_pages=1)

@app.route('/media/covers/<cover_id>')
def image(cover_id):
    cover = Cover.query.get(cover_id)
    if cover is None:
        abort(404)
    return send_from_directory(app.config['UPLOAD_FOLDER'], cover.file_name)

# @app.route('/add_book', methods=['GET', 'POST'])
# @login_required
# def add_book():
#     if request.method == 'POST':
#         title = request.form['title']
#         description = request.form['description']
#         year = request.form['publication_year']
#         publisher = request.form['publisher']
#         author = request.form['author']
#         page_count = request.form['pages']
#         cover_id = request.form['cover_id']

#         query = """
#             INSERT INTO books (title, description, publication_year, publisher, author, pages, cover_id)
#             VALUES (%s, %s, %s, %s, %s, %s, %s)
#         """

#         try:
#             with db.connection().cursor() as cursor:
#                 cursor.execute(query, (title, description, year, publisher, author, page_count, cover_id))
#                 db.connection().commit()
#                 flash('Книга успешно добавлена!', 'success')
#                 return redirect(url_for('index'))
#         except mysql.connector.errors.DatabaseError:
#             flash('Произошла ошибка при добавлении книги.', 'danger')

#     return render_template('add_book.html')

if __name__ == '__main__':
    app.run(debug=True)