from flask_login import current_user
from functools import wraps
from flask import redirect, flash, url_for

class CheckRights:
    def add(self):
        return current_user.is_admin()

    def delete(self):
        return current_user.is_admin()

    def edit(self):
        return current_user.is_admin() or current_user.is_moder()

    def show(self):
        return current_user.is_authenticated

def admin_required(f):
    @wraps(f)
    def decorated_function(*args, **kwargs):
        if not current_user.is_authenticated or not current_user.is_admin():
            flash('У вас недостаточно прав для доступа к данной странице.', 'danger')
            return redirect(url_for('index'))
        return f(*args, **kwargs)
    return decorated_function
