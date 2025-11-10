# Real‑World DevOps with Nix (Portfolio Edition)

A clean, production‑style showcase that demonstrates reproducible developer environments, containerization, Kubernetes deployment, Terraform IaC, and CI with GitHub Actions — centered around a tiny Go HTTP service.

**Tech Stack**
- Go, Nix flakes, Docker, Kubernetes, Terraform, GitHub Actions

**Features**
- Reproducible dev environment via `flake.nix` (multi‑platform)
- Containerized Go service (`cmd/todos`) with multi‑stage Dockerfile
- Kubernetes manifests (Deployment/Service/Ingress) ready for cluster deploys
- CI pipeline that tests Go, builds a Docker image via Nix, and optionally pushes
- Minimal Terraform example to illustrate IaC patterns

## Quickstart
- Nix dev shell: `nix develop`
- Build Go: `make build`
- Docker (classic): `make docker-build` (edit `<YOUR_DOCKER_USERNAME>`)
- Docker (via Nix): `make nix-docker`
- Apply K8s: `make k8s-apply`
- Delete K8s: `make k8s-delete`

Service runs on port 8080, with `GET /health` and `GET /todos`.

## Kubernetes
- Deployment: `k8s/deployment.yaml` (name: `todos-api`, replicas: 2)
- Service: `k8s/service.yaml` (ClusterIP 80 -> 8080)
- Ingress: `k8s/ingress.yaml` (host `todos.local` -> service)

Default container image is `your-docker-username/todos:latest`. Override via CI, `kubectl set image`, or your preferred GitOps tool.

## CI (GitHub Actions)
- Workflow: `.github/workflows/ci.yml`
- Installs Nix, runs Go tests in dev shell, builds Docker image via Nix
- If `DOCKERHUB_USERNAME` and `DOCKERHUB_TOKEN` are configured as repo secrets, the built image is pushed automatically

## Terraform
- Minimal, cloud‑agnostic example in `main.tf` using the `random` provider
- Demonstrates providers/outputs without requiring credentials
- Validates with `terraform validate`

## Nix Flake
- Inputs: `nixpkgs` (unstable), `flake-utils`
- DevShell includes: go, docker, docker-compose, kubectl, helm, kustomize, terraform, tflint, doctl, jq, git, gnumake
- Packages:
  - `packages.todos`: Go binary built with `buildGoModule`
  - `packages.default`: alias to `todos`
  - `packages.dockerImage` (Linux): minimal image with only the compiled binary

## Notes
- This repository is designed as a learning/portfolio asset for reviewers and recruiters. The application logic is intentionally simple; the focus is high‑quality, reproducible DevOps workflows.
- Linux is assumed for most examples; macOS is supported via the flake dev shell.
