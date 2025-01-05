#!/bin/bash

# ============================================================
# Car Deals Finder - Automated GitHub Repository Setup for macOS 18+
# ============================================================

# Function for displaying colored messages
display_message() {
    case "$2" in
        success)
            echo -e "\033[32m✔️ $1\033[0m"  # Green for success
            ;;
        error)
            echo -e "\033[31m❌ $1\033[0m"  # Red for error
            ;;
        info)
            echo -e "\033[34mℹ️ $1\033[0m"  # Blue for info
            ;;
        warning)
            echo -e "\033[33m⚠️ $1\033[0m"  # Yellow for warnings
            ;;
        *)
            echo -e "$1"  # Default, no color
            ;;
    esac
}

# Prompt for GitHub Username and Repository
read -p "Enter your GitHub username: " GITHUB_USER
read -p "Enter the name of your repository (e.g., CarDealsFinder): " REPO_NAME

# Prompt for GitHub credentials
read -sp "Enter your GitHub personal access token or password: " GITHUB_TOKEN
echo ""

# ============================================================
# 1. Initialize Git Repository
# ============================================================
display_message "Initializing local Git repository..." "info"
git init || { display_message "Failed to initialize Git repository." "error"; exit 1; }
git add . || { display_message "Failed to add files to Git." "error"; exit 1; }
git commit -m "Initial commit of Car Deals Finder" || { display_message "Failed to commit changes." "error"; exit 1; }

# ============================================================
# 2. Check if GitHub Repository exists
# ============================================================
display_message "Checking if GitHub repository exists..." "info"
REPO_EXISTS=$(curl -s -o /dev/null -w "%{http_code}" "https://api.github.com/repos/$GITHUB_USER/$REPO_NAME")

if [ "$REPO_EXISTS" -eq 404 ]; then
    # Create a new repository if it doesn't exist
    display_message "Repository not found. Creating a new repository on GitHub..." "info"
    curl -u "$GITHUB_USER:$GITHUB_TOKEN" -X POST -d "{\"name\":\"$REPO_NAME\", \"description\":\"A web app to find the best car deals online with AutoScout24 data. Supports multiple languages, real-time scraping, and filters.\"}" "https://api.github.com/user/repos" || { display_message "Failed to create GitHub repository." "error"; exit 1; }
    display_message "Repository created successfully!" "success"
else
    display_message "Repository already exists on GitHub." "info"
fi

# ============================================================
# 3. Link to GitHub Repository
# ============================================================
display_message "Linking to GitHub repository..." "info"
git remote add origin "https://$GITHUB_USER:$GITHUB_TOKEN@github.com/$GITHUB_USER/$REPO_NAME.git" || { display_message "Failed to link to GitHub repository." "error"; exit 1; }

# ============================================================
# 4. Push to GitHub
# ============================================================
display_message "Pushing to GitHub repository..." "info"
git push -u origin main || { display_message "Failed to push to GitHub repository." "error"; exit 1; }

# ============================================================
# 5. Set Up Repository Settings for SEO and Collaboration
# ============================================================
display_message "Setting up repository for SEO and collaboration..." "info"

# Setting repository description, website, and topics (SEO optimization)
curl -u "$GITHUB_USER:$GITHUB_TOKEN" -X PATCH -d '{"name":"'$REPO_NAME'","description":"A web app to find the best car deals online with AutoScout24 data. Supports multiple languages, real-time scraping, and filters.","homepage":"https://yourwebsite.com","topics":["car-deals","web-scraping","python","flask","open-source"]}' "https://api.github.com/repos/$GITHUB_USER/$REPO_NAME"

# ============================================================
# 6. Create a GitHub Release
# ============================================================
display_message "Creating GitHub release..." "info"
git tag -a v1.0 -m "Initial Release" || { display_message "Failed to create GitHub release." "error"; exit 1; }
git push --tags || { display_message "Failed to push tags to GitHub." "error"; exit 1; }

# ============================================================
# 7. Add .gitignore for Common Files
# ============================================================
display_message "Adding .gitignore..." "info"
echo -e "*.pyc\n__pycache__\n.venv/" > .gitignore
git add .gitignore
git commit -m "Added .gitignore to exclude unwanted files"
git push

# ============================================================
# 8. Complete Setup
# ============================================================
display_message "GitHub repository setup is complete!" "success"

# Provide instructions for further use
display_message "You can now access your repository at https://github.com/$GITHUB_USER/$REPO_NAME" "info"
display_message "To view the app, go to the hosted page (or local server if in Standalone mode)." "info"
display_message "To contribute, make sure to fork and submit pull requests." "info"

# End of script
