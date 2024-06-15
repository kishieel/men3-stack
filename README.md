# MNNN Stack

Development stack leveraging MySQL, NestJS, NextJS, and NodeJS for scalable and efficient web applications.

## Structure

backend/ - NestJS application 

frontend/ - NextJS application

deployment/ - set of terraform tools to deploy application into aws with two flavors "development" and "production"

"development" starts everything in Docker conainter with Docker Compose on single instance.

"production" starts everything following best practices for scalable and highly available deployment, so managed database, public network for frontend and private network for backend and database. Horizontal autoscaling.

## Tools

- Docker compose for local development.
- Linter and prettier.
- Test coverage (backend: unit, integration; frontend: unit, e2e)
- CI/CD.
