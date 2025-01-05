class Config:
    """Base configuration class."""
    SECRET_KEY = os.environ.get('SECRET_KEY', 'your_secret_key')
    SQLALCHEMY_DATABASE_URI = 'sqlite:///car_deals.db'  # SQLite database
    SQLALCHEMY_TRACK_MODIFICATIONS = False
    LANGUAGES = ['en', 'it', 'de', 'fr']
    CACHE_TYPE = 'simple'
    CACHE_DEFAULT_TIMEOUT = 300
    UPLOAD_FOLDER = 'uploads'
    MAX_CONTENT_LENGTH = 16 * 1024 * 1024  # Max upload size (16 MB)
