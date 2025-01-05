from flask import Flask
from config import Config
from flask_sqlalchemy import SQLAlchemy
from app.models import db

def create_app():
    app = Flask(__name__)
    app.config.from_object(Config)

    # Initialize SQLAlchemy
    db.init_app(app)

    with app.app_context():
        # Create database tables
        db.create_all()

    return app
