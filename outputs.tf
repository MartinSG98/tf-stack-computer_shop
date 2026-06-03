output "api_url" {
  description = "Base invoke URL of the HTTP API."
  value       = module.computer_shop.api_url
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

output "lambda_function_name" {
  value = module.computer_shop.lambda_function_name
}

output "github_deploy_role_arn" {
  description = "IAM role ARN for GitHub Actions to assume via OIDC."
  value       = module.computer_shop.github_deploy_role_arn
}
