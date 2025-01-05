import requests
from flask import Blueprint, render_template, jsonify
from app.models import CarDeal, db
from bs4 import BeautifulSoup

# Create blueprint for the main routes
bp = Blueprint('main', __name__)

@bp.route('/')
def index():
    return render_template('index.html')  # Render the main page

@bp.route('/api/recommendations', methods=["GET"])
def recommendations():
    try:
        # Scraping logic for live car recommendations from AutoScout24
        base_url = "https://www.autoscout24.it/lst/"
        headers = {"User-Agent": "Mozilla/5.0"}
        params = {
            "pricefrom": 5000,
            "priceto": 30000,
            "sort": "price",
            "size": 4,  # Number of cars to fetch
        }

        # Send GET request to fetch data
        response = requests.get(base_url, headers=headers, params=params)
        response.raise_for_status()  # Raise an exception for HTTP errors

        # Parse the HTML content
        soup = BeautifulSoup(response.text, "html.parser")
        
        # Extract car details from the page
        cars = []
        for car in soup.select(".cl-list-element-gap")[:4]:  # Fetch the top 4 cars
            title = car.select_one(".title").get_text(strip=True)
            price = car.select_one(".price").get_text(strip=True)
            mileage = car.select_one(".mileage").get_text(strip=True)
            year = car.select_one(".first-registration").get_text(strip=True)
            
            # Store car details in a dictionary
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
        
        db.session.commit()  # Commit the transaction to the database

        # Return the scraped data as JSON
        if cars:
            return jsonify(cars)
        else:
            return jsonify({"message": "No car deals found"}), 404  # No cars found

    except requests.exceptions.RequestException as e:
        return jsonify({"error": f"Error fetching car deals: {str(e)}"}), 500
    except Exception as e:
        return jsonify({"error": f"An unexpected error occurred: {str(e)}"}), 500
