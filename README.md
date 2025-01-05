# Car Deals Finder - Version 1.0

Car Deals Finder is a web application designed to help users find the best car deals online by scraping data from AutoScout24. The app supports multiple languages (English, Italian, German, and French) and allows users to filter car deals based on their preferences.

---

## 🚀 Features
- **Internationalization**: Supports **English**, **Italian**, **German**, and **French**.
- **Real-time Car Deal Recommendations**: Fetches up-to-date data from **AutoScout24**.
- **Filters**: Max price, Min year, and Fuel type for customized results.
- **SSL with Let's Encrypt**: Secure browsing (optional).
- **GitHub Collaboration**: Contribute to the project by collaborating with the GitHub repository.
- **Easy Setup & Uninstallation**: Automated installation and uninstallation scripts.
- **User-Friendly Interface**: Simple and easy-to-use frontend to display the best car deals.

---

## 🔧 Prerequisites

Before installation, make sure you have the following:
- **Linux or macOS** (Windows may need additional setup).
- **Python 3.8+** installed.
- **Git** (Optional for versioning and collaboration).
- **Nginx** (Optional, for production setup).

---

## 💻 Installation Guide

### 1. Download the repository
Clone the repository and navigate into the project directory:

```bash
git clone https://github.com/yourusername/CarDealsFinder.git
cd CarDealsFinder

2. Run the installer script

Run the installation script to set up the application and configure SSL. Optionally, you can also enable GitHub collaboration during the setup.

sudo ./scripts/install.sh

You’ll be prompted to:
    •    Choose between Client-Server or Standalone mode.
    •    Configure SSL with Let’s Encrypt (optional).
    •    Provide your GitHub username for collaboration (optional).

The script will automatically:
    •    Install all required dependencies.
    •    Set up your virtual environment.
    •    Configure SSL (if chosen).
    •    Set up systemd services or start the standalone server.

3. Access the application
    •    Client-Server Mode: Open your browser and go to http://<your_domain_or_localhost>.
    •    Standalone Mode: The app will be accessible at http://localhost:8000.
    
🛠 Optional GitHub Collaboration

During installation, you can choose to contribute to the GitHub repository by providing your GitHub username. This will clone the repository into your app directory, allowing you to contribute and push your changes.

🎯 Usage

Once installed, you can begin using the app:
    1.    Open the app in your browser.
    2.    Apply filters: Max Price, Min Year, and Fuel Type to search for car deals.
    3.    Browse the results: Detailed information including the title, price, mileage, and year.

❌ Uninstallation Guide

To uninstall the app, simply run the uninstallation script:

sudo ./scripts/uninstall.sh

This will:
    •    Remove all application files.
    •    Disable and remove systemd services.
    •    Delete the virtual environment.
    •    Remove Nginx configurations.
    
💡 Monetization Opportunities

The Car Deals Finder project is licensed under the MIT License, meaning you can freely use, modify, and distribute the software. Here are some ways you can monetize the application:

Monetization Strategies:
    1.    Affiliate Links: Integrate affiliate programs with car marketplaces, earning a commission on successful transactions.
    2.    Premium Features: Offer additional features for premium users, such as notifications for new deals, advanced search filters, or custom recommendations.
    3.    Donations & Crowdfunding: Set up donation buttons or use crowdfunding platforms to fund further development.
    
👥 Contributing

Feel free to fork the repository and make pull requests. If you’d like to contribute directly, please follow the steps for GitHub collaboration during installation.

📝 License

This project is licensed under the MIT License. You are free to use, modify, and distribute the software. However, we do not assume any liability for damages or issues caused by using this software.

⚠️ Troubleshooting

If you run into any issues, consider the following:
    •    Dependencies: Make sure all required dependencies are installed.
    •    Permissions: Run the script with root privileges if needed.
    •    Logs: Check installation.log for installation errors or uninstallation.log for uninstallation issues.
