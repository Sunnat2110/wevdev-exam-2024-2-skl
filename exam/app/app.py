from typing import Dict
from flask import Flask, render_template, request, redirect, url_for, flash
from flask_login import LoginManager, UserMixin, login_user, logout_user, login_required, current_user
from mysql_db import MySQL
import mysql.connector
from werkzeug.utils import secure_filename
import re

app = Flask(__name__)

application = app

app.config.from_pyfile('config.py')

db = MySQL(app)

login_manager = LoginManager()
login_manager.init_app(app)

login_manager.login_view = 'login'
login_manager.login_message = 'Для доступа необходимо пройти аутентификацию'
login_manager.login_message_category = 'warning'


class User(UserMixin):
    def __init__(self, user_id, user_login):
        self.id = user_id
        self.login = user_login

@login_manager.user_loader
def load_user(user_id):
    query = 'SELECT id, login FROM users WHERE id = %s'

    with db.connection().cursor(named_tuple=True) as cursor:
        cursor.execute(query, (user_id,))
        user = cursor.fetchone()

        return User(user.id, user.login) if user else None


@app.route('/')
@app.route('/page/<int:page>')
def index(page=1):
    per_page = 10  # Количество книг на одной странице
    offset = (page - 1) * per_page

    query = '''
        SELECT books.id, books.title, books.publication_year, 
               AVG(reviews.rating) as avg_rating, COUNT(reviews.id) as review_count
        FROM books
        LEFT JOIN reviews ON books.id = reviews.book_id
        GROUP BY books.id
        ORDER BY books.year DESC
        LIMIT %s OFFSET %s
    '''
    
    with db.connection().cursor(named_tuple=True) as cursor:
        cursor.execute(query, (per_page, offset))
        books = cursor.fetchall()
    
    # Подсчет общего количества книг для правильной работы пагинации
    count_query = 'SELECT COUNT(*) as total_books FROM books'
    with db.connection().cursor(named_tuple=True) as cursor:
        cursor.execute(count_query)
        total_books = cursor.fetchone().total_books
    
    total_pages = (total_books + per_page - 1) // per_page  # Общее количество страниц
    
    return render_template('index.html', books=books, page=page, total_pages=total_pages)


@app.route('/login', methods=['POST', 'GET'])
def login():
    if request.method == 'POST':
        login = request.form['login']
        password = request.form['password']
        check = request.form.get('secretcheck') == 'on'

        query = 'SELECT id, login FROM users WHERE login=%s AND password_hash=SHA2(%s, 256)'

        try:
            with db.connection().cursor(named_tuple=True) as cursor:
                cursor.execute(query, (login, password))
                user = cursor.fetchone()

                if user:
                    login_user(User(user.id, user.login), remember=check)
                    next_url = request.args.get('next') or url_for('index')
                    flash('Вы успешно вошли!', 'success')
                    return redirect(next_url)
                else:
                    flash('Неверные учетные данные.', 'danger')

        except mysql.connector.errors.DatabaseError:
            flash('Произошла ошибка при входе.', 'danger')

    return render_template('login.html')

@app.route('/logout', methods=['GET'])
def logout():
    logout_user()
    return redirect(url_for('index'))

@app.route('/add_book', methods=['GET', 'POST'])
@login_required
def add_book():
    if request.method == 'POST':
        title = request.form['title']
        description = request.form['description']
        year = request.form['year']
        publisher = request.form['publisher']
        author = request.form['author']
        page_count = request.form['page_count']
        cover_id = request.form['cover_id']

        query = """
            INSERT INTO books (title, description, year, publisher, author, page_count, cover_id)
            VALUES (%s, %s, %s, %s, %s, %s, %s)
        """

        try:
            with db.connection().cursor() as cursor:
                cursor.execute(query, (title, description, year, publisher, author, page_count, cover_id))
                db.connection().commit()
                flash('Книга успешно добавлена!', 'success')
                return redirect(url_for('index'))
        except mysql.connector.errors.DatabaseError:
            flash('Произошла ошибка при добавлении книги.', 'danger')

    return render_template('add_book.html')

if __name__ == '__main__':
    app.run(debug=True)
