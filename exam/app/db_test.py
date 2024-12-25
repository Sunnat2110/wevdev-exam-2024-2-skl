import pytest
from app import app, db
from models import User
from werkzeug.security import generate_password_hash
from sqlalchemy.exc import IntegrityError
from sqlalchemy import text

@pytest.fixture
def client():
    """Создание клиента для теста с откатом транзакций."""
    with app.test_client() as client:
        with app.app_context():
            db.create_all()  # Создаём все таблицы в базе данных
        yield client
        with app.app_context():
            db.session.remove()  # Закрываем сессию после теста

@pytest.fixture(autouse=True)
def rollback():
    """Откатывает транзакцию после каждого теста."""
    # Начинаем транзакцию
    with app.app_context():
        db.session.begin()
        yield
        # Откатываем все изменения после теста
        db.session.rollback()

def test_database_query(client):
    """Простой тест на выполнение SQL-запроса."""
    with app.app_context():
        query = text('SELECT 1')
        result = db.session.execute(query)
        assert result.scalar() == 1, "Запрос к базе данных вернул неверный результат"

def test_user_authentication(client):
    """Тест аутентификации пользователя с хэшированием пароля."""
    with app.app_context():
        # Проверяем, существует ли пользователь с таким логином
        existing_user = User.query.filter_by(login="user1").first()
        if existing_user:
            db.session.delete(existing_user)
            db.session.commit()

        # Создаём новый хэш пароля
        password_hash = generate_password_hash("qwerty")
        print(f"Generated password hash: {password_hash}")

        # Создаём нового пользователя с хэшом пароля
        user = User(login="user1", password_hash=password_hash, last_name="ivanov", first_name="ivan", middle_name="ivanovich", role_id=1)
        db.session.add(user)

        try:
            db.session.commit()  # Сохраняем пользователя в базе данных
        except IntegrityError:
            db.session.rollback()  # Откатываем изменения в случае ошибки целостности
            raise  # Повторно поднимаем исключение, чтобы тест не прошёл

    # Выполняем запрос для аутентификации пользователя
    response = client.post('/auth/login', data={'login': 'user1', 'password': 'qwerty'})
    assert response.status_code == 302, f"Ожидался статус 302, но получен {response.status_code}"  # Ожидаем редирект (302)
