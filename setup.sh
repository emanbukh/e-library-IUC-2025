#!/bin/bash

# Koha Git Deployment Setup Script
# This script helps you set up Koha using Git deployment

set -e

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${BLUE}🚀 Koha Git Deployment Setup${NC}"
echo "=================================="
echo ""

# Check if git is installed
if ! command -v git &> /dev/null; then
    echo -e "${YELLOW}📦 Installing Git...${NC}"
    if [[ "$OSTYPE" == "darwin"* ]]; then
        # macOS
        brew install git
    elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
        # Linux
        sudo apt update && sudo apt install -y git
    else
        echo -e "${YELLOW}⚠️  Please install Git manually${NC}"
        exit 1
    fi
fi

# Check if we're in a git repository
if [ ! -d ".git" ]; then
    echo -e "${YELLOW}📁 Initializing Git repository...${NC}"
    git init
    git remote add origin https://github.com/emanbukh/e-library-IUC-2025.git
fi

# Make scripts executable
echo -e "${YELLOW}🔧 Making scripts executable...${NC}"
chmod +x deployment/koha-install.sh
chmod +x deployment/scripts/backup.sh
chmod +x deployment/scripts/update.sh

# Create deployment branch
echo -e "${YELLOW}🌿 Creating deployment branch...${NC}"
git checkout -b deployment 2>/dev/null || git checkout deployment

# Add all files
echo -e "${YELLOW}📝 Adding files to Git...${NC}"
git add .

# Commit changes
echo -e "${YELLOW}💾 Committing changes...${NC}"
git commit -m "Setup Git-based deployment for Koha" || echo "No changes to commit"

# Show setup options
echo -e "${GREEN}✅ Setup completed successfully!${NC}"
echo ""
echo -e "${BLUE}🎯 Choose your deployment method:${NC}"
echo ""
echo -e "${YELLOW}🏠 LOCAL DEVELOPMENT:${NC}"
echo "1. Install MAMP/XAMPP for local web server"
echo "2. Follow LOCAL_SETUP.md for detailed instructions"
echo "3. Access at: http://localhost/koha/opac"
echo ""
echo -e "${YELLOW}🌐 PRODUCTION SERVER:${NC}"
echo "1. Follow QUICK_START_GIT.md for server setup"
echo "2. Use GIT_DEPLOYMENT.md for detailed instructions"
echo "3. Access at: http://yourdomain.com/koha/opac"
echo ""
echo -e "${BLUE}📋 Next Steps:${NC}"
echo "1. Push to GitHub: git push origin deployment"
echo "2. Choose local or server setup"
echo "3. Follow the appropriate guide"
echo ""
echo -e "${BLUE}📚 Documentation:${NC}"
echo "- Local Setup: LOCAL_SETUP.md"
echo "- Quick Start: QUICK_START_GIT.md"
echo "- Full Guide: GIT_DEPLOYMENT.md"
echo "- Repository: https://github.com/emanbukh/e-library-IUC-2025.git"
echo ""
echo -e "${GREEN}🎉 Ready for Git-based deployment!${NC}"
echo ""
echo -e "${YELLOW}💡 Tip: For local development, install MAMP and follow LOCAL_SETUP.md${NC}" 