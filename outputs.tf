output "api_url" {
  description = "Base invoke URL of the HTTP API."
  value       = module.computer_shop.api_url
}

output "api_custom_domain_url" {
  description = "Custom domain URL of the API (null if not configured)."
  value       = module.computer_shop.api_custom_domain_url
}

output "cdn_base_url" {
  description = "CloudFront base URL for product images (use as CDN_BASE_URL)."
  value       = module.computer_shop.cdn_base_url
}

output "products_table_name" {
  value = module.computer_shop.products_table_name
}

output "categories_table_name" {
  value = module.computer_shop.categories_table_name
}

output "images_bucket_name" {
  value = module.computer_shop.images_bucket_name
}

output "frontend_bucket_name" {
  value = module.computer_shop.frontend_bucket_name
}

output "frontend_url" {
  description = "CloudFront URL of the frontend app."
  value       = module.computer_shop.frontend_url
}

output "site_custom_domain_url" {
  description = "Custom domain URL of the site (null if not configured)."
  value       = module.computer_shop.site_custom_domain_url
}

output "frontend_distribution_id" {
  value = module.computer_shop.frontend_distribution_id
}

output "github_frontend_deploy_role_arn" {
  description = "IAM role ARN for the frontend GitHub Actions to assume via OIDC."
  value       = module.computer_shop.github_frontend_deploy_role_arn
}

output "lambda_function_name" {
  value = module.computer_shop.lambda_function_name
}

output "github_deploy_role_arn" {
  description = "IAM role ARN for GitHub Actions to assume via OIDC."
  value       = module.computer_shop.github_deploy_role_arn
}

output "eval_lambda_function_name" {
  value = module.computer_shop.eval_lambda_function_name
}

output "models_bucket_name" {
  value = module.computer_shop.models_bucket_name
}

output "eval_model_key" {
  value = module.computer_shop.eval_model_key
}

output "github_eval_deploy_role_arn" {
  description = "IAM role ARN for the build-evaluator CI to assume via OIDC."
  value       = module.computer_shop.github_eval_deploy_role_arn
}

output "eval_url" {
  description = "Build-evaluator endpoint (POST)."
  value       = module.computer_shop.eval_url
}

output "agent_runtime_arn" {
  description = "AgentCore runtime ARN of the support agent."
  value       = module.computer_shop.agent_runtime_arn
}

output "agent_runtime_id" {
  description = "AgentCore runtime id (target for the agent CI's update-agent-runtime)."
  value       = module.computer_shop.agent_runtime_id
}

output "agent_artifacts_bucket_name" {
  description = "S3 bucket the support-agent CI uploads the code zip to."
  value       = module.computer_shop.agent_artifacts_bucket_name
}

output "agent_code_key" {
  description = "S3 key of the support-agent code zip."
  value       = module.computer_shop.agent_code_key
}

output "github_agent_deploy_role_arn" {
  description = "IAM role ARN for the support-agent CI to assume via OIDC."
  value       = module.computer_shop.github_agent_deploy_role_arn
}
