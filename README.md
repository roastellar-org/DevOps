# ArenaX DevOps

Infrastructure and deployment configuration for the ArenaX platform. Covers container orchestration, CI/CD pipelines, Kubernetes manifests, and reverse proxy setup for the backend, frontend, and PostgreSQL services.

## Architecture Overview

```
Frontend ──► NGINX (reverse proxy)
                 │
                 ├──► Backend API (Express)
                 │          │
                 │          └──► PostgreSQL
                 └──► Static assets
```

## Components

- **docker-compose.yml** — local development stack
- **.github/workflows/ci.yml** — CI pipeline
- **kubernetes/** — deployment manifests
- **nginx/** — reverse proxy configuration
- **docs/** — deployment documentation

## Status

Initial setup. Manifests and pipelines are being scaffolded incrementally.
