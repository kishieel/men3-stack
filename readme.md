# MEN<sup>3</sup> Stack

Development stack leveraging MySQL, Expo, NestJS, NextJS, and NodeJS for scalable and efficient web applications.

## Structure

backend/ - NestJS application 

frontend/ - NextJS application

mobile/ - Expo application

deployment/ - set of terraform tools to deploy application into aws with two flavors "development" and "production"

"development" starts everything in Docker container with Docker Compose on single instance.

"production" starts everything following best practices for scalable and highly available deployment, so managed database, public network for frontend and private network for backend and database. Horizontal autoscaling.

## Tools

- Docker compose for local development.
- Linter and prettier.
- Test coverage (backend: unit, integration; frontend: unit, e2e)
- CI/CD.

## CI/CD

### Pull Request

- Linting
- Unit tests
- Build images
- Push images to registry
- Start containers
- Integration tests

### Merge to Master

- Build images
- Push images to registry
- Deploy to development environment

### New Tag

- Build images
- Push images to registry
- Deploy to production environment
