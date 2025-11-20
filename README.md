# Django + Vue + CockroachDB Template

A production-ready full-stack template with Django REST Framework backend, Vue 3 frontend, and CockroachDB database, all orchestrated with Docker Compose.

## Tech Stack

### Backend
- **Django 5.0+** - Python web framework
- **Django REST Framework** - API toolkit
- **CockroachDB** - Distributed SQL database
- **Gunicorn** - Production WSGI server
- **JWT Authentication** - djangorestframework-simplejwt

### Frontend
- **Vue 3** - Progressive JavaScript framework
- **Vite** - Next-generation build tool
- **Pinia** - State management
- **Vue Router** - Client-side routing
- **Tailwind CSS** - Utility-first CSS framework
- **Axios** - HTTP client

### Infrastructure
- **Docker & Docker Compose** - Containerization
- **Nginx** - Production web server (frontend)

---

## Quick Start

### Prerequisites

- [Docker Desktop](https://www.docker.com/products/docker-desktop/) (v20.10+)
- [Git](https://git-scm.com/)

### 1. Clone the Repository

```bash
git clone <repository-url>
cd fullstack-test
```

### 2. Setup Environment Variables

```bash
# Backend
cp backend/.env.example backend/.env

# Frontend
cp frontend/.env.example frontend/.env
```

Edit the `.env` files with your configuration. **Important**: Change `SECRET_KEY` and passwords for production!

### 3. Start Development Environment

```bash
# Using Make (recommended)
make dev

# Or manually
docker-compose up -d --build
cd frontend && npm install && npm run dev
```

### 4. Access the Application

| Service | URL | Description |
|---------|-----|-------------|
| Frontend | http://localhost:5173 | Vue development server |
| Backend API | http://localhost:8000/api | Django REST API |
| Django Admin | http://localhost:8000/admin | Admin interface |
| CockroachDB UI | http://localhost:8080 | Database dashboard |

Default admin credentials (change in production!):
- Username: `admin`
- Password: `changeme123`

---

## Project Structure

```
fullstack-test/
├── backend/                    # Django backend
│   ├── api/                    # Main API app
│   │   ├── models.py           # Database models
│   │   ├── serializers.py      # DRF serializers
│   │   ├── views.py            # API views
│   │   └── urls.py             # API routes
│   ├── backend/                # Django project config
│   │   ├── settings.py         # Main settings
│   │   ├── urls.py             # Root URL config
│   │   └── wsgi.py             # WSGI config
│   ├── Dockerfile              # Development Dockerfile
│   ├── Dockerfile.prod         # Production Dockerfile
│   ├── requirements.txt        # Python dependencies
│   ├── entrypoint.sh           # Container entrypoint
│   └── .env.example            # Environment template
├── frontend/                   # Vue 3 frontend
│   ├── src/
│   │   ├── components/         # Vue components
│   │   ├── router/             # Vue Router config
│   │   ├── stores/             # Pinia stores
│   │   ├── App.vue             # Root component
│   │   └── main.js             # Entry point
│   ├── Dockerfile              # Development Dockerfile
│   ├── Dockerfile.prod         # Production Dockerfile
│   ├── nginx.conf              # Nginx configuration
│   ├── package.json            # Node dependencies
│   └── .env.example            # Environment template
├── docker-compose.yml          # Base Docker Compose
├── docker-compose.override.yml # Development overrides
├── docker-compose.prod.yml     # Production config
├── Makefile                    # Common commands
├── init.sql                    # Database initialization
└── README.md                   # This file
```

---

## Development

### Available Commands

Use `make help` to see all available commands:

```bash
make dev          # Start development environment
make down         # Stop all containers
make logs         # View container logs
make shell-back   # Shell into backend container
make shell-front  # Shell into frontend container
make test         # Run all tests
make lint         # Run linters
make clean        # Clean up containers and volumes
```

### Backend Development

```bash
# Access Django shell
make shell-back
python manage.py shell

# Create new migrations
python manage.py makemigrations

# Apply migrations
python manage.py migrate

# Create a new app
python manage.py startapp myapp
```

### Frontend Development

```bash
# Install dependencies
cd frontend && npm install

# Run development server
npm run dev

# Build for production
npm run build

# Lint code
npm run lint

# Format code
npm run format
```

### Database

CockroachDB runs on port `26257`. Access the admin UI at http://localhost:8080.

```bash
# Connect to CockroachDB shell
docker-compose exec db cockroach sql --insecure --database=mydb

# Useful SQL commands
SHOW TABLES;
SELECT * FROM api_yourmodel;
```

---

## Configuration

### Environment Variables

#### Backend (`backend/.env`)

| Variable | Description | Default |
|----------|-------------|---------|
| `DEBUG` | Django debug mode | `1` |
| `SECRET_KEY` | Django secret key | Required |
| `ALLOWED_HOSTS` | Comma-separated hosts | `*` |
| `DATABASE_URL` | Database connection URL | See `.env.example` |
| `DJANGO_SUPERUSER_*` | Auto-created admin | See `.env.example` |
| `CORS_ALLOWED_ORIGINS` | Allowed CORS origins | All in dev |

#### Frontend (`frontend/.env`)

| Variable | Description | Default |
|----------|-------------|---------|
| `VITE_API_BASE_URL` | Backend API URL | `http://localhost:8000/api` |
| `VITE_APP_TITLE` | Application title | `My App` |

### Django Settings

Key settings in `backend/backend/settings.py`:

```python
# Security (production)
SECURE_SSL_REDIRECT = True
SESSION_COOKIE_SECURE = True
CSRF_COOKIE_SECURE = True

# CORS
CORS_ALLOWED_ORIGINS = ["https://yourdomain.com"]

# Static files
STATIC_ROOT = BASE_DIR / "staticfiles"
MEDIA_ROOT = BASE_DIR / "media"
```

### Adding New Django Apps

1. Create the app:
   ```bash
   cd backend
   python manage.py startapp myapp
   ```

2. Add to `INSTALLED_APPS` in `settings.py`:
   ```python
   INSTALLED_APPS += [
       "myapp",
   ]
   ```

3. Create models, serializers, views, and URLs.

### Adding New Vue Components

1. Create component in `frontend/src/components/`
2. Import and use in your views
3. Add routes in `frontend/src/router/index.js`

---

## Production Deployment

### Build Production Images

```bash
make build-prod
```

### Run Production Stack

```bash
make prod
```

This uses:
- **Gunicorn** for Django (instead of runserver)
- **Nginx** for Vue (optimized static serving)
- Production-optimized configurations

### Production Checklist

Before deploying to production:

- [ ] Change `SECRET_KEY` to a secure random value
- [ ] Set `DEBUG=0`
- [ ] Configure `ALLOWED_HOSTS` with your domain
- [ ] Set `CORS_ALLOWED_ORIGINS` to your frontend domain
- [ ] Enable SSL/HTTPS
- [ ] Set secure cookie settings
- [ ] Configure proper logging
- [ ] Set up database backups
- [ ] Configure reverse proxy (Nginx/Traefik)
- [ ] Set up monitoring and alerting

### Environment-Specific Configs

```bash
# Development
docker-compose up -d

# Production
docker-compose -f docker-compose.yml -f docker-compose.prod.yml up -d
```

---

## API Documentation

### Authentication

The API uses JWT (JSON Web Tokens) for authentication.

```bash
# Obtain token
POST /api/token/
{
  "username": "admin",
  "password": "changeme123"
}

# Response
{
  "access": "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9...",
  "refresh": "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9..."
}

# Refresh token
POST /api/token/refresh/
{
  "refresh": "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9..."
}

# Use token in requests
Authorization: Bearer <access_token>
```

### Available Endpoints

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/api/hello/` | Test endpoint |
| POST | `/api/token/` | Obtain JWT token |
| POST | `/api/token/refresh/` | Refresh JWT token |

---

## Testing

### Backend Tests

```bash
# Run all tests
make test-back

# Run specific test
docker-compose exec backend pytest api/tests/ -v

# With coverage
docker-compose exec backend pytest --cov=api
```

### Frontend Tests

```bash
# Run tests
make test-front

# Or manually
cd frontend && npm run test
```

---

## Troubleshooting

### Common Issues

#### Database connection refused
```bash
# Wait for CockroachDB to be ready
docker-compose logs db

# Restart backend after DB is ready
docker-compose restart backend
```

#### Migrations fail
```bash
# Reset migrations (development only!)
docker-compose exec backend python manage.py migrate --fake api zero
docker-compose exec backend python manage.py migrate
```

#### Frontend can't connect to API
- Check `VITE_API_BASE_URL` in `frontend/.env`
- Ensure backend CORS settings allow frontend origin
- Check browser console for CORS errors

#### Permission denied on entrypoint.sh
```bash
chmod +x backend/entrypoint.sh
```

### Logs

```bash
# All services
make logs

# Specific service
docker-compose logs -f backend
docker-compose logs -f frontend
docker-compose logs -f db
```

### Reset Everything

```bash
make clean
make dev
```

---

## Customization Guide

### Changing the Database

While this template uses CockroachDB, you can switch to PostgreSQL:

1. Update `docker-compose.yml`:
   ```yaml
   db:
     image: postgres:15
     environment:
       POSTGRES_DB: mydb
       POSTGRES_USER: postgres
       POSTGRES_PASSWORD: password
   ```

2. Update `backend/requirements.txt`:
   ```
   # Remove django-cockroachdb
   # Keep psycopg2-binary
   ```

3. Update `DATABASE_URL` in `.env`:
   ```
   DATABASE_URL=postgres://postgres:password@db:5432/mydb
   ```

4. Update `settings.py` to use standard PostgreSQL engine.

### Adding Authentication to Frontend

1. Create auth store in `frontend/src/stores/auth.js`
2. Add login/register components
3. Configure Axios interceptors for JWT
4. Add route guards in Vue Router

### Adding New API Endpoints

1. Create model in `backend/api/models.py`
2. Create serializer in `backend/api/serializers.py`
3. Create viewset in `backend/api/views.py`
4. Register routes in `backend/api/urls.py`

---

## Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

---

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

## Support

If you encounter issues:

1. Check the [Troubleshooting](#troubleshooting) section
2. Search existing issues
3. Open a new issue with:
   - Description of the problem
   - Steps to reproduce
   - Expected vs actual behavior
   - Logs and error messages
