terraform {
  required_version = ">= 1.5"

  required_providers {
    aws = {
      source = "hashicorp/aws"
      # 6.21+ is needed for the AgentCore runtime (support agent) in the module.
      version = "~> 6.21"
    }
  }

  # State is local for now. Migrate to an S3 backend + lock table when this
  # becomes a shared/CI-managed deployment.
}