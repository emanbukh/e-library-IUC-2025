#!/bin/bash

# Koha Docker Setup Script
# This script automates the installation of Koha with Elasticsearch

set -e  # Exit on any error

echo "🚀 Starting Koha Docker Setup..."

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if Docker is running
if ! docker info > /dev/null 2>&1; then
    print_error "Docker is not running. Please start Docker Desktop and try again."
    exit 1
fi

# Check if we're in the right directory
if [ ! -f "docker-compose.yml" ]; then
    print_error "Please run this script from the koha-testing-docker directory"
    exit 1
fi

# Set environment variables
export PROJECTS_DIR=$(pwd)/..
export SYNC_REPO=$PROJECTS_DIR/koha
export KTD_HOME=$PROJECTS_DIR/koha-testing-docker
export PATH=$PATH:$KTD_HOME/bin
export LOCAL_USER_ID=$(id -u)

print_status "Setting up environment variables..."

# Check if Koha source code exists
if [ ! -d "../koha" ]; then
    print_status "Cloning Koha source code..."
    cd ..
    git clone --branch main --single-branch https://git.koha-community.org/Koha-community/Koha.git koha
    cd koha-testing-docker
else
    print_status "Koha source code already exists"
fi

# Configure environment
if [ ! -f ".env" ]; then
    print_status "Creating environment configuration..."
    cp env/defaults.env .env
    
    # Enable Elasticsearch
    sed -i '' 's/KOHA_ELASTICSEARCH=/KOHA_ELASTICSEARCH=yes/' .env
    sed -i '' 's/KOHA_DOMAIN=.myDNSname.org/KOHA_DOMAIN=.localhost/' .env
else
    print_status "Environment configuration already exists"
fi

# Pull Docker images
print_status "Pulling Docker images (this may take a while)..."
./bin/ktd pull

# Stop any existing containers
print_status "Stopping any existing containers..."
./bin/ktd down 2>/dev/null || true

# Start services
print_status "Starting Koha services..."
./bin/ktd up -d

# Wait for services to be ready
print_status "Waiting for services to be ready..."
sleep 30

# Check if services are running
if docker compose ps | grep -q "Up"; then
    print_status "✅ Koha setup completed successfully!"
    echo ""
    echo "🌐 Access Koha at:"
    echo "   Staff Interface: http://localhost:8081"
    echo "   OPAC: http://localhost:8080"
    echo ""
    echo "🔑 Default login credentials:"
    echo "   Username: koha"
    echo "   Password: koha"
    echo ""
    echo "📚 Useful commands:"
    echo "   View logs: ./bin/ktd --logs"
    echo "   Stop services: ./bin/ktd down"
    echo "   Access shell: ./bin/ktd --shell"
    echo ""
    print_status "Setup complete! 🎉"
else
    print_error "Some services failed to start. Check logs with: ./bin/ktd --logs"
    exit 1
fi 