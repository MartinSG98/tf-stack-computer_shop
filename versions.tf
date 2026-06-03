terraform {
  required_version = ">= 1.5"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  # State is local for now. Migrate to an S3 backend + lock table when this
  # becomes a shared/CI-managed deployment.
}