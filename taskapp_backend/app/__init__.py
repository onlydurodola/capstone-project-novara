from flask import Flask
from flask_sqlalchemy import SQLAlchemy
from flask_cors import CORS
import os
from dotenv import load_dotenv
from urllib.parse import quote_plus
from werkzeug.security import generate_password_hash

db = SQLAlchemy()

load_dotenv()


def seed_default_data():
    from app.models import Task, User

    if User.query.first() is None:
        db.session.add_all([
            User(username='admin', password_hash=generate_password_hash('admin123')),
            User(username='user', password_hash=generate_password_hash('user123')),
        ])

    if Task.query.first() is None:
        db.session.add_all([
            Task(
                title='Setup Project Repository',
                description='Initialize git repository and create project structure',
                priority='high',
                status='done',
            ),
            Task(
                title='Design Database Schema',
                description='Create PostgreSQL database schema for task management',
                priority='high',
                status='done',
            ),
            Task(
                title='Implement REST API',
                description='Build Flask REST API with CRUD operations',
                priority='high',
                status='in_progress',
            ),
            Task(
                title='Create Frontend UI',
                description='Build React frontend with Kanban board',
                priority='medium',
                status='in_progress',
            ),
            Task(
                title='Add Authentication',
                description='Implement user authentication and authorization',
                priority='medium',
                status='todo',
            ),
            Task(
                title='Write Documentation',
                description='Create comprehensive README and API documentation',
                priority='low',
                status='todo',
            ),
        ])

    db.session.commit()

def create_app():
    app = Flask(__name__)

    database_uri = os.getenv('DATABASE_URL')

    # Fall back to split database connection details when DATABASE_URL is not set.
    db_host = os.getenv('DATABASE_HOST')
    db_port = os.getenv('DATABASE_PORT', '5432')
    db_name = os.getenv('DATABASE_NAME')
    db_user = os.getenv('DATABASE_USER')
    db_password = os.getenv('DATABASE_PASSWORD')

    if not database_uri and db_host and db_user and db_name and db_password:
        encoded_password = quote_plus(db_password)
        database_uri = (
            f"postgresql://{db_user}:{encoded_password}@{db_host}:{db_port}/{db_name}"
        )

    if not database_uri:
        database_uri = 'postgresql://taskapp_user:taskapp_password@localhost:5432/taskapp'

    app.config['SQLALCHEMY_DATABASE_URI'] = database_uri
    app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False
    app.config['SECRET_KEY'] = os.getenv('SECRET_KEY', 'dev-secret-key-change-in-production')

    db.init_app(app)
    CORS(app)

    from app.routes import api_bp
    app.register_blueprint(api_bp, url_prefix='/api')

    with app.app_context():
        db.create_all()
        seed_default_data()

    return app