# Contributing Guide

Thank you for considering contributing to this project!

## Development Setup

1. Fork and clone the repository
2. Run the setup script: `./scripts/setup.sh` (or `make setup`)
3. Start the development environment: `make dev`
4. Start the frontend: `cd frontend && npm run dev`

## Code Style

### Backend (Python)
- Follow PEP 8 guidelines
- Use Black for formatting: `black .`
- Use isort for imports: `isort .`
- Run flake8 for linting: `flake8 .`

### Frontend (JavaScript/Vue)
- Follow ESLint configuration
- Use Prettier for formatting: `npm run format`
- Run lint before committing: `npm run lint`

## Commit Messages

Use clear, descriptive commit messages:
- `feat:` for new features
- `fix:` for bug fixes
- `docs:` for documentation
- `refactor:` for code refactoring
- `test:` for tests
- `chore:` for maintenance

Example: `feat: add user authentication endpoint`

## Pull Request Process

1. Create a feature branch from `develop`
2. Make your changes
3. Run tests: `make test`
4. Run linters: `make lint`
5. Update documentation if needed
6. Submit a PR to `develop`

## Testing

- Backend: `make test-back`
- Frontend: `make test-front`
- All tests: `make test`

## Questions?

Open an issue for questions or suggestions.
