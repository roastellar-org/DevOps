# ArenaX Deployment Guide

High-level overview of how the ArenaX platform is intended to be deployed.

## Deployment Flow

1. Developers push code to the `GameBackend` and `Frontend` repositories.
2. GitHub Actions builds and tests each service, then publishes container images to the container registry.
3. Images are deployed to a Kubernetes cluster via `kubectl` (manifests in `kubernetes/`).
4. NGINX (`nginx/default.conf`) acts as the public entry point and reverse proxies requests to the backend API and frontend.

## CI/CD Pipeline

- `.github/workflows/ci.yml` runs on every push to `main` and on pull requests.
- Pipeline stages: install dependencies → lint → build.
- Follow-up stages (test, publish, deploy) are planned.

## Docker

- `docker-compose.yml` defines the local development stack:
  - **backend** — ArenaX API (Express)
  - **frontend** — web client
  - **db** — PostgreSQL

## Kubernetes

- `kubernetes/deployment.yaml` contains a sample Deployment and Service for the backend.
- Deployment runs 2 replicas with resource requests/limits.
- Database credentials are injected from a Kubernetes Secret.

## NGINX

- `nginx/default.conf` configures the reverse proxy:
  - `/api/*` routes to the backend service.
  - `/` routes to the frontend.
  - Standard proxy headers are forwarded.

## Planned Work

- TLS/HTTPS termination.
- Horizontal Pod Autoscaling.
- Monitoring and log aggregation (Prometheus + Grafana).
- Terraform manifests for cloud infrastructure.
