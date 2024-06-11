"""populate covers table

Revision ID: <your_revision_id>
Revises: <previous_revision_id>
Create Date: <date>

"""
from alembic import op
import sqlalchemy as sa
from sqlalchemy.orm import sessionmaker
from models import Cover
import os
from werkzeug.datastructures import FileStorage
from tools import ImageSaver
from config import UPLOAD_FOLDER

# revision identifiers, used by Alembic.
revision = '0c5d054a005b'
down_revision = None
branch_labels = None
depends_on = None

def upgrade():
    # Create the Flask app context
        # Bind the session to the engine
        bind = op.get_bind()
        Session = sessionmaker(bind=bind)
        session = Session()

        # Directory containing the images
        upload_folder = UPLOAD_FOLDER

        # Iterate over each file in the directory
        for filename in os.listdir(upload_folder):
            filepath = os.path.join(upload_folder, filename)
            
            # Skip if not a file
            if not os.path.isfile(filepath):
                continue

            # Create a FileStorage object from the file
            with open(filepath, 'rb') as file:
                file_storage = FileStorage(stream=file, filename=filename, content_type='image/jpg')  # Adjust content_type if needed

                # Use ImageSaver to save the file and add record to the database
                saver = ImageSaver(file_storage)
                saver.save()

        session.commit()

def downgrade():
    # Create the Flask app context
        # Bind the session to the engine
        bind = op.get_bind()
        Session = sessionmaker(bind=bind)
        session = Session()

        # Clear all records from the covers table
        session.query(Cover).delete()
        session.commit()
