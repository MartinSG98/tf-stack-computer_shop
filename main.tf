module "computer_shop" {
  # Local path during development. Switch to a pinned version when releasing:
  #   source = "git::https://github.com/MartinSG98/tf-module-computer_shop.git?ref=v0.2.0"
  source = "../tf-module-computer_shop"

  providers = {
    aws           = aws
    aws.us_east_1 = aws.us_east_1
  }

  project               = var.project
  cors_allow_origins    = var.cors_allow_origins
  github_deploy_repos   = var.github_deploy_repos
  github_frontend_repos = var.github_frontend_repos

  api_domain_name  = var.api_domain_name
  site_domain_name = var.site_domain_name
  hosted_zone_name = var.hosted_zone_name

  api_throttle_rate_limit  = var.api_throttle_rate_limit
  api_throttle_burst_limit = var.api_throttle_burst_limit
}
