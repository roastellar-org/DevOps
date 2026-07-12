# ArenaX Deployment Guide

Complete overview of the ArenaX deployment architecture and operational flow.

## Deployment Flow

1. Developers push code to the `GameBackend` and `Frontend` repositories.
2. GitHub Actions runs the **Test** pipeline (lint, unit tests, build) on every push.
3. The **Build** pipeline publishes container images to GHCR (`ghcr.io/roastellar`).
4. The **Deploy** pipeline applies Kubernetes manifests to the cluster.
5. NGINX terminates TLS and reverse proxies traffic to the backend API and frontend.
6. Prometheus scrapes metrics; Grafana renders dashboards; alerts page the on-call engineer.

## CI/CD Pipelines

All workflows live in `.github/workflows/`:

| Workflow | Trigger | Purpose |
|----------|---------|---------|
| `build.yml` | push to main, tags, PRs | Docker builds, GHCR publishing |
| `test.yml` | push to main, PRs | Lint, unit tests, build (with ephemeral Postgres) |
| `deploy.yml` | manual dispatch, version tags | `kubectl apply` + rollout verification |

Deployments target two environments:

- **staging** — every push to `main`
- **production** — version tags (`v*`) and manual dispatch

## Docker

- `Dockerfile.backend` — multi-stage Node.js build (deps → compile → slim runtime)
- `Dockerfile.frontend` — static build served by NGINX
- `docker-compose.yml` — local development stack with healthchecks and env templates
- `docker-compose.prod.yml` — production stack including the NGINX gateway

## Infrastructure (Terraform)

- `terraform/provider.tf` — AWS provider, S3 remote state, DynamoDB locking
- `terraform/main.tf` — VPC (2 AZs, NAT gateway) and EKS cluster with managed node groups
- `terraform/variables.tf` / `outputs.tf` — environment-driven configuration

## Kubernetes

All manifests are in `kubernetes/`, applied to the `arenax` namespace:

- `namespace.yaml` — namespace, resource quota, limit range
- `secrets.yaml` / `configmap.yaml` — configuration injection
- `backend-deployment.yaml` / `frontend-deployment.yaml` — workloads with probes and resource limits
- `postgres-statefulset.yaml` — persistent database with PVC
- `ingress.yaml` — NGINX ingress with TLS
- `production/` — production-specific overrides (cert-manager, rate limits)

## Monitoring

- `monitoring/prometheus/prometheus.yml` — scrape configs for pods, API server, node exporter
- `monitoring/prometheus/alert-rules.yml` — error rate, latency, disk, CPU throttling alerts
- `monitoring/grafana/` — provisioned datasource and ArenaX backend dashboard
- `monitoring/node-exporter.yaml` — host metrics DaemonSet

## NGINX

- `nginx/nginx.conf` — main configuration (workers, gzip, logging)
- `nginx/default.conf` — TLS listener, backend upstream, security headers
- `nginx/ssl.conf` — HTTP→HTTPS redirect with ACME challenge passthrough

## Bug Fixes

- Backend startup race condition resolved with an init container (see git history).
- Readiness probe corrected to the `/health` endpoint.
- CI cache keys fixed to invalidate on dependency changes.
