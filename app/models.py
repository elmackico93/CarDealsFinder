from flask_sqlalchemy import SQLAlchemy

# Initialize SQLAlchemy
db = SQLAlchemy()

# Car Deal Model
class CarDeal(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    title = db.Column(db.String(255), nullable=False)
    price = db.Column(db.String(50), nullable=False)
    mileage = db.Column(db.String(50), nullable=False)
    year = db.Column(db.String(10), nullable=False)
    fuel_type = db.Column(db.String(50), nullable=True)
    created_at = db.Column(db.DateTime, default=db.func.current_timestamp())

    def __repr__(self):
        return f"<CarDeal {self.title} - {self.price}>"

# User Preferences Model (optional)
class UserPreference(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    max_price = db.Column(db.Integer, nullable=True)
    min_year = db.Column(db.Integer, nullable=True)
    fuel_type = db.Column(db.String(50), nullable=True)
    created_at = db.Column(db.DateTime, default=db.func.current_timestamp())

    def __repr__(self):
        return f"<UserPreference {self.id}>"
