from flask import Flask
from config import configurations
from flask_sqlalchemy import SQLAlchemy
from flask_caching import Cache

# Initialize extensions
db = SQLAlchemy()
cache = Cache()

def create_app(config_name='production'):
    """
    Factory function to create and configure the Flask app.
    
    Args:
        config_name (str): Configuration name (e.g., 'development', 'production').
    
    Returns:
        Flask app instance.
    """
    app = Flask(__name__)
    app.config.from_object(configurations[config_name])

    # Initialize extensions
    db.init_app(app)
    cache.init_app(app)

    with app.app_context():
        # Ensure database tables are created
        db.create_all()

        # Register blueprints
        from app.main import bp as main_bp
        app.register_blueprint(main_bp)

    return app