# =========================
# Makefile for Django + Vue + CockroachDB
# =========================
# Run 'make help' to see all available commands

.PHONY: help dev down logs build test lint clean shell-back shell-front migrate setup prod build-prod

# Default target
.DEFAULT_GOAL := help

# Colors for terminal output
YELLOW := \033[1;33m
GREEN := \033[1;32m
NC := \033[0m # No Color

help: ## Show this help message
	@echo ""
	@echo "$(GREEN)Available commands:$(NC)"
	@echo ""
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "  $(YELLOW)%-15s$(NC) %s\n", $$1, $$2}'
	@echo ""

# =========================
# Development Commands
# =========================

setup: ## First-time setup: copy env files and install dependencies
	@echo "$(GREEN)Setting up project...$(NC)"
	@if [ ! -f backend/.env ]; then cp backend/.env.example backend/.env && echo "Created backend/.env"; fi
	@if [ ! -f frontend/.env ]; then cp frontend/.env.example frontend/.env && echo "Created frontend/.env"; fi
	@echo "Installing frontend dependencies..."
	@cd frontend && npm install
	@echo "$(GREEN)Setup complete! Run 'make dev' to start.$(NC)"

dev: ## Start development environment
	@echo "$(GREEN)Starting development environment...$(NC)"
	docker-compose up -d --build
	@echo ""
	@echo "$(GREEN)Backend running at:$(NC) http://localhost:8000"
	@echo "$(GREEN)CockroachDB UI at:$(NC) http://localhost:8080"
	@echo ""
	@echo "$(YELLOW)Start frontend with:$(NC) cd frontend && npm run dev"

down: ## Stop all containers
	@echo "$(GREEN)Stopping containers...$(NC)"
	docker-compose down

logs: ## View container logs (follow mode)
	docker-compose logs -f

logs-back: ## View backend logs only
	docker-compose logs -f backend

logs-db: ## View database logs only
	docker-compose logs -f db

# =========================
# Shell Access
# =========================

shell-back: ## Open shell in backend container
	docker-compose exec backend sh

shell-db: ## Open CockroachDB SQL shell
	docker-compose exec db cockroach sql --insecure --database=mydb

# =========================
# Django Commands
# =========================

migrate: ## Run Django migrations
	docker-compose exec backend python manage.py migrate

makemigrations: ## Create new Django migrations
	docker-compose exec backend python manage.py makemigrations

createsuperuser: ## Create Django superuser
	docker-compose exec backend python manage.py createsuperuser

collectstatic: ## Collect static files
	docker-compose exec backend python manage.py collectstatic --noinput

django-shell: ## Open Django shell
	docker-compose exec backend python manage.py shell

# =========================
# Testing
# =========================

test: test-back test-front ## Run all tests

test-back: ## Run backend tests
	@echo "$(GREEN)Running backend tests...$(NC)"
	docker-compose exec backend pytest -v

test-back-cov: ## Run backend tests with coverage
	docker-compose exec backend pytest --cov=api --cov-report=html

test-front: ## Run frontend tests
	@echo "$(GREEN)Running frontend tests...$(NC)"
	cd frontend && npm run test 2>/dev/null || echo "No test script configured"

# =========================
# Code Quality
# =========================

lint: lint-back lint-front ## Run all linters

lint-back: ## Lint backend code
	@echo "$(GREEN)Linting backend...$(NC)"
	docker-compose exec backend flake8 . || true
	docker-compose exec backend black --check . || true

lint-front: ## Lint frontend code
	@echo "$(GREEN)Linting frontend...$(NC)"
	cd frontend && npm run lint

format: ## Format all code
	@echo "$(GREEN)Formatting code...$(NC)"
	docker-compose exec backend black .
	docker-compose exec backend isort .
	cd frontend && npm run format

# =========================
# Production
# =========================

build-prod: ## Build production Docker images
	@echo "$(GREEN)Building production images...$(NC)"
	docker-compose -f docker-compose.yml -f docker-compose.prod.yml build

prod: ## Start production environment
	@echo "$(GREEN)Starting production environment...$(NC)"
	docker-compose -f docker-compose.yml -f docker-compose.prod.yml up -d
	@echo ""
	@echo "$(GREEN)Production environment running!$(NC)"
	@echo "$(GREEN)Frontend:$(NC) http://localhost"
	@echo "$(GREEN)Backend API:$(NC) http://localhost:8000"

prod-down: ## Stop production environment
	docker-compose -f docker-compose.yml -f docker-compose.prod.yml down

prod-logs: ## View production logs
	docker-compose -f docker-compose.yml -f docker-compose.prod.yml logs -f

# =========================
# Cleanup
# =========================

clean: ## Stop containers and remove volumes
	@echo "$(GREEN)Cleaning up...$(NC)"
	docker-compose down -v --remove-orphans
	@echo "$(GREEN)Cleanup complete!$(NC)"

clean-all: clean ## Full cleanup including images
	@echo "$(GREEN)Removing images...$(NC)"
	docker-compose down --rmi local -v --remove-orphans
	@echo "$(GREEN)Full cleanup complete!$(NC)"

# =========================
# Utilities
# =========================

ps: ## Show running containers
	docker-compose ps

restart: ## Restart all containers
	docker-compose restart

restart-back: ## Restart backend container
	docker-compose restart backend

status: ## Show status of all services
	@echo "$(GREEN)Service Status:$(NC)"
	@docker-compose ps
	@echo ""
	@echo "$(GREEN)Checking health endpoints...$(NC)"
	@curl -s http://localhost:8000/api/health/ 2>/dev/null || echo "Backend: Not responding"
	@curl -s http://localhost:8080/health?ready=1 2>/dev/null | head -1 || echo "Database: Not responding"
