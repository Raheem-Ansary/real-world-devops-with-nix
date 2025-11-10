.PHONY: dev build docker-build nix-docker k8s-apply k8s-delete

dev:
	nix develop

build:
	go build -o bin/todos ./cmd/todos

docker-build:
	docker build -t <YOUR_DOCKER_USERNAME>/todos:latest .

nix-docker:
	nix build .#packages.x86_64-linux.dockerImage

k8s-apply:
	kubectl apply -f k8s/

k8s-delete:
	kubectl delete -f k8s/ || true
