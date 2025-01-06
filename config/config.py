import os

class Config:
    """Base configuration class for Car Deals Finder."""
    
    # Security
    SECRET_KEY = os.environ.get('SECRET_KEY', 'your_secret_key')
    
    # Database
    SQLALCHEMY_DATABASE_URI = os.environ.get('DATABASE_URL', 'sqlite:///car_deals.db')
    SQLALCHEMY_TRACK_MODIFICATIONS = False
    
    # Languages
    LANGUAGES = ['en', 'it', 'de', 'fr']
    
    # Cache
    CACHE_TYPE = 'simple'
    CACHE_DEFAULT_TIMEOUT = 300
    
    # Upload Settings
    UPLOAD_FOLDER = 'uploads'
    MAX_CONTENT_LENGTH = 16 * 1024 * 1024  # Max upload size: 16MB
    
    # Other
    DEBUG = os.environ.get('DEBUG', False)

class DevelopmentConfig(Config):
    """Development-specific configuration."""
    DEBUG = True
    SQLALCHEMY_DATABASE_URI = 'sqlite:///dev_car_deals.db'

class ProductionConfig(Config):
    """Production-specific configuration."""
    DEBUG = False
    SQLALCHEMY_DATABASE_URI = os.environ.get('DATABASE_URL', 'sqlite:///prod_car_deals.db')

# Map configurations
configurations = {
    'development': DevelopmentConfig,
    'production': ProductionConfig
}