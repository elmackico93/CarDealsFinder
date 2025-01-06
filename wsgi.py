from app import create_app

# Create and configure the Flask app
app = create_app()

if __name__ == "__main__":
    # Use the default port for deployment compatibility
    app.run(host="0.0.0.0", port=8000)