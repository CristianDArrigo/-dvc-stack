#!/bin/bash
# =========================
# First-time Setup Script
# =========================
# Run this script after cloning the repository

set -e

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${GREEN}================================${NC}"
echo -e "${GREEN}  Project Setup Script${NC}"
echo -e "${GREEN}================================${NC}"
echo ""

# Check prerequisites
echo -e "${YELLOW}Checking prerequisites...${NC}"

# Check Docker
if ! command -v docker &> /dev/null; then
    echo -e "${RED}Error: Docker is not installed.${NC}"
    echo "Please install Docker Desktop from https://www.docker.com/products/docker-desktop/"
    exit 1
fi
echo "  ✓ Docker installed"

# Check Docker Compose
if ! command -v docker-compose &> /dev/null; then
    echo -e "${RED}Error: Docker Compose is not installed.${NC}"
    exit 1
fi
echo "  ✓ Docker Compose installed"

# Check Node.js
if ! command -v node &> /dev/null; then
    echo -e "${RED}Error: Node.js is not installed.${NC}"
    echo "Please install Node.js 20+ from https://nodejs.org/"
    exit 1
fi
NODE_VERSION=$(node -v)
echo "  ✓ Node.js installed ($NODE_VERSION)"

# Check npm
if ! command -v npm &> /dev/null; then
    echo -e "${RED}Error: npm is not installed.${NC}"
    exit 1
fi
echo "  ✓ npm installed"

echo ""

# Setup environment files
echo -e "${YELLOW}Setting up environment files...${NC}"

if [ ! -f backend/.env ]; then
    cp backend/.env.example backend/.env
    echo "  ✓ Created backend/.env"
else
    echo "  → backend/.env already exists (skipped)"
fi

if [ ! -f frontend/.env ]; then
    cp frontend/.env.example frontend/.env
    echo "  ✓ Created frontend/.env"
else
    echo "  → frontend/.env already exists (skipped)"
fi

echo ""

# Install frontend dependencies
echo -e "${YELLOW}Installing frontend dependencies...${NC}"
cd frontend
npm install
cd ..
echo "  ✓ Frontend dependencies installed"

echo ""

# Build and start Docker containers
echo -e "${YELLOW}Building and starting Docker containers...${NC}"
docker-compose up -d --build

echo ""

# Wait for services to be ready
echo -e "${YELLOW}Waiting for services to be ready...${NC}"
sleep 10

# Check services
echo ""
echo -e "${GREEN}================================${NC}"
echo -e "${GREEN}  Setup Complete!${NC}"
echo -e "${GREEN}================================${NC}"
echo ""
echo "Services are running at:"
echo "  • Backend API:    http://localhost:8000/api"
echo "  • Django Admin:   http://localhost:8000/admin"
echo "  • CockroachDB UI: http://localhost:8080"
echo ""
echo "To start the frontend development server:"
echo -e "  ${YELLOW}cd frontend && npm run dev${NC}"
echo ""
echo "Default admin credentials:"
echo "  • Username: admin"
echo "  • Password: changeme123"
echo ""
echo -e "${RED}IMPORTANT: Change the SECRET_KEY and passwords in .env files for production!${NC}"
echo ""
echo "Useful commands:"
echo "  • make help      - Show all available commands"
echo "  • make logs      - View container logs"
echo "  • make down      - Stop all containers"
echo "  • make clean     - Remove containers and volumes"
echo ""
