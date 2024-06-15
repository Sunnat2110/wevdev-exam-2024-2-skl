import os

SQLALCHEMY_DATABASE_URI = 'mysql+mysqlconnector://std_2533_exam:12345678@std-mysql.ist.mospolytech.ru/std_2533_exam'
SQLALCHEMY_TRACK_MODIFICATIONS = False
SQLALCHEMY_ECHO = True
SECRET_KEY = 'f038a541489b89f81762d12edfdd03835ceea10cfb3cdbdabfbfa0f48b0d4802'

UPLOAD_FOLDER = os.path.join(os.path.dirname(os.path.abspath(__file__)), 'media', 'covers')
