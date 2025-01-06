import requests
from flask import Blueprint, render_template, jsonify
from app.models import CarDeal, db
from bs4 import BeautifulSoup

# Create blueprint for the main routes
bp = Blueprint('main', __name__)

@bp.route('/')
def index():
    """
    Render the main page of the application.
    """
    return render_template('index.html')

@bp.route('/api/recommendations', methods=["GET"])
def recommendations():
    """
    Fetch live car recommendations from AutoScout24.
    
    Returns:
        JSON response containing car deals or an error message.
    """
    try:
        # Define scraping parameters
        base_url = "https://www.autoscout24.it/lst/"
        headers = {"User-Agent": "Mozilla/5.0"}
        params = {
            "pricefrom": 5000,
            "priceto": 30000,
            "sort": "price",
            "size": 4,  # Number of cars to fetch
        }

        # Send GET request to fetch car deals
        response = requests.get(base_url, headers=headers, params=params)
        response.raise_for_status()

        # Parse the HTML content
        soup = BeautifulSoup(response.text, "html.parser")
        
        # Extract car details
        cars = []
        for car in soup.select(".cl-list-element-gap")[:4]:
            try:
                title = car.select_one(".title").get_text(strip=True)
                price = car.select_one(".price").get_text(strip=True)
                mileage = car.select_one(".mileage").get_text(strip=True)
                year = car.select_one(".first-registration").get_text(strip=True)

                # Append car details to the list
                cars.append({
                    "title": title,
                    "price": price,
                    "mileage": mileage,
                    "year": year
                })

                # Save the car deal to the database
                new_deal = CarDeal(
                    title=title,
                    price=price,
                    mileage=mileage,
                    year=year
                )
                db.session.add(new_deal)
            except AttributeError:
                # Skip any car that doesn't have complete data
                continue

        db.session.commit()  # Commit all valid car deals to the database

        # Return JSON response
        return jsonify(cars) if cars else jsonify({"message": "No car deals found"}), 404

    except requests.exceptions.RequestException as e:
        return jsonify({"error": f"Error fetching car deals: {str(e)}"}), 500
    except Exception as e:
        return jsonify({"error": f"An unexpected error occurred: {str(e)}"}), 500