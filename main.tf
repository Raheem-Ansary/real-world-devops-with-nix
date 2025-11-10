terraform {
  required_version = ">= 1.5.0"
  required_providers {
    random = {
      source  = "hashicorp/random"
      version = ">= 3.5.0"
    }
  }
}

# Simple, generic IaC example (no real credentials)
locals {
  project_name = "real-world-devops-with-nix"
  environment  = "dev"
}

resource "random_pet" "suffix" {
  length = 2
}

output "project_name" {
  description = "The project name for demos/CI"
  value       = local.project_name
}

output "example_id" {
  description = "A random suffix to show reproducible outputs"
  value       = random_pet.suffix.id
}
