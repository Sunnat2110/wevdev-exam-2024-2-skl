import os
from werkzeug.security import check_password_hash, generate_password_hash
from flask_login import UserMixin
from flask import url_for
from flask_sqlalchemy import SQLAlchemy
from sqlalchemy.orm import DeclarativeBase, relationship
from sqlalchemy import MetaData
from check_rights import CheckRights
from datetime import datetime

class Base(DeclarativeBase):
  metadata = MetaData(naming_convention={
        "ix": 'ix_%(column_0_label)s',
        "uq": "uq_%(table_name)s_%(column_0_name)s",
        "ck": "ck_%(table_name)s_%(constraint_name)s",
        "fk": "fk_%(table_name)s_%(column_0_name)s_%(referred_table_name)s",
        "pk": "pk_%(table_name)s"
    })

db = SQLAlchemy(model_class=Base)

class User(db.Model, UserMixin):
    __tablename__ = 'users'
    
    id = db.Column(db.Integer, primary_key=True)
    login = db.Column(db.String(50), unique=True, nullable=False)
    password_hash = db.Column(db.String(128), nullable=False)
    last_name = db.Column(db.String(50))
    first_name = db.Column(db.String(50))
    middle_name = db.Column(db.String(50))
    role_id = db.Column(db.Integer, db.ForeignKey('roles.id', ondelete='CASCADE'), nullable=False)
    visits = db.relationship('Visit', back_populates='user')

    def __repr__(self):
        return '<User: %r>' % self.login

    def set_password(self, password):
        self.password_hash = generate_password_hash(password)

    def check_password(self, password):
        return check_password_hash(self.password_hash, password)
    
    def is_admin(self):
        return self.role_id == 1

    def is_moder(self):
        return self.role_id == 2

    def can(self, action, record=None):
        check_user = CheckRights()
        method = getattr(check_user, action, None)
        if method:
            return method()
        return False


class Cover(db.Model):
    __tablename__ = 'covers'
    id = db.Column(db.Integer, primary_key=True)
    file_name = db.Column(db.String(50), nullable=False)
    mime_type = db.Column(db.String(100), nullable=False)
    md5_hash = db.Column(db.String(150), nullable=False)

    def __repr__(self):
        return '<Cover: %r>' % self.file_name

    @property
    def storage_filename(self):
        _, ext = os.path.splitext(self.file_name)
        return _ + ext

    @property
    def url(self):
        return url_for('covers', cover_id=self.id)
    
class Book(db.Model):
    __tablename__ = 'books'

    id = db.Column(db.Integer, primary_key=True)
    title = db.Column(db.String(255), nullable=False)
    description = db.Column(db.Text, nullable=False)
    year = db.Column(db.Integer, nullable=False)
    publisher = db.Column(db.String(255), nullable=False)
    author = db.Column(db.String(255), nullable=False)
    pages = db.Column(db.Integer, nullable=False)
    cover_id = db.Column(db.Integer, db.ForeignKey('covers.id', ondelete='CASCADE'), nullable=True)
    visits = relationship('Visit', back_populates='book')


    def __repr__(self):
        return '<Book {}>'.format(self.title)
    
class BookGenre(db.Model):
    __tablename__ = 'book_genres'
    book_id = db.Column(db.Integer, db.ForeignKey('books.id', ondelete='CASCADE'), primary_key=True)
    genre_id = db.Column(db.Integer, db.ForeignKey('genres.id', ondelete='CASCADE'), primary_key=True)

    book = db.relationship('Book')
    genre = db.relationship('Genre')

class Review(db.Model):
    __tablename__ = 'reviews'
    id = db.Column(db.Integer, primary_key=True)
    book_id = db.Column(db.Integer, db.ForeignKey('books.id', ondelete='CASCADE'))
    user_id = db.Column(db.Integer, db.ForeignKey('users.id', ondelete='CASCADE'))
    rating = db.Column(db.Integer)
    text = db.Column(db.Text)
    created_at = db.Column(db.DateTime)

    def __repr__(self):
        return f'<Reviews: {self.user_id} {self.created_at}>'
    
    def get_user(self):
        return db.session.execute(db.select(User).filter_by(id=self.user_id)).scalar().login

class Genre(db.Model):
    __tablename__ = 'genres'
    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String(100), unique=True)

    def __repr__(self):
        return '<Genre: %r>' % self.name
    
class Role(db.Model):
    __tablename__ = 'roles'
    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String(20), nullable=False)
    description = db.Column(db.Text)

    def __repr__(self):
        return '<User: %r>' % self.name
    
class Visit(db.Model):
    __tablename__ = 'visits'
    id = db.Column(db.Integer, primary_key=True)
    user_id = db.Column(db.Integer, db.ForeignKey('users.id'), nullable=True)
    book_id = db.Column(db.Integer, db.ForeignKey('books.id'), nullable=False)
    visit_time = db.Column(db.DateTime, default=datetime.utcnow)

    user = db.relationship('User', backref=db.backref('visit_logs', lazy=True))
    book = db.relationship('Book', backref=db.backref('visit_logs', lazy=True))