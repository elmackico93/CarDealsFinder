from flask_sqlalchemy import SQLAlchemy
from datetime import datetime

# Initialize SQLAlchemy
db = SQLAlchemy()

class CarDeal(db.Model):
    """Model for storing car deal information."""
    
    __tablename__ = 'car_deals'

    id = db.Column(db.Integer, primary_key=True)
    title = db.Column(db.String(255), nullable=False)
    price = db.Column(db.String(50), nullable=False)
    mileage = db.Column(db.String(50), nullable=False)
    year = db.Column(db.String(50), nullable=False)
    added_on = db.Column(db.DateTime, default=datetime.utcnow)

    def __repr__(self):
        return f"<CarDeal {self.title}, {self.price}>"

    def to_dict(self):
        """Serialize model data to dictionary format."""
        return {
            "id": self.id,
            "title": self.title,
            "price": self.price,
            "mileage": self.mileage,
            "year": self.year,
            "added_on": self.added_on.isoformat()
        }