module "computer_shop" {
  # Local path during development. Switch to a pinned version when releasing:
  #   source = "git::https://github.com/MartinSG98/tf-module-computer_shop.git?ref=v0.1.0"
  source = "../tf-module-computer_shop"

  project             = var.project
  cors_allow_origins  = var.cors_allow_origins
  github_deploy_repos = var.github_deploy_repos

  api_throttle_rate_limit  = var.api_throttle_rate_limit
  api_throttle_burst_limit = var.api_throttle_burst_limit
}
