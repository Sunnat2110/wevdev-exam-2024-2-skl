from models import Cover
import hashlib
import os
from werkzeug.utils import secure_filename
from app import db
from flask import current_app


class ImageSaver:
    def __init__(self, file):
        self.file = file

    def save(self):
        self.img = self.__find_by_md5_hash()
        if self.img is not None:
            return self.__find_by_md5_hash().id
        file_name = secure_filename(self.file.filename)
        last_id = Cover.query.order_by(Cover.id.desc()).first()
        if last_id is None:
            last_id = 0
        else: last_id = last_id.id
        self.img = Cover(
            id=last_id + 1,
            file_name=str(last_id + 1) + file_name,
            mime_type=self.file.mimetype,
            md5_hash=self.md5_hash)
        print(os.path.join(current_app.config['UPLOAD_FOLDER'],self.img.storage_filename))
        self.file.save(
            os.path.join(current_app.config['UPLOAD_FOLDER'],
                         self.img.storage_filename))
        db.session.add(self.img)
        db.session.commit()
        return self.img.id

    def __find_by_md5_hash(self):
        self.md5_hash = hashlib.md5(self.file.read()).hexdigest()
        self.file.seek(0)
        return Cover.query.filter(Cover.md5_hash == self.md5_hash).first()