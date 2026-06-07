variable "aws_region" {
  description = "AWS region to deploy into."
  type        = string
  default     = "eu-west-2"
}

variable "project" {
  description = "Project name; prefix for resource names and tags."
  type        = string
  default     = "computer-shop"
}

variable "cors_allow_origins" {
  description = "EXTRA CORS origins beyond the frontend CloudFront URL (which is always allowed). E.g. a custom domain or http://localhost:5173."
  type        = string
  default     = ""
}

variable "github_deploy_repos" {
  description = "GitHub repos (owner/name) whose main branch may assume the backend deploy role."
  type        = list(string)
  default     = ["MartinSG98/computer-shop-backend"]
}

variable "github_frontend_repos" {
  description = "GitHub repos (owner/name) whose main branch may assume the frontend deploy role."
  type        = list(string)
  default     = ["MartinSG98/computer_shop_ui"]
}

variable "github_eval_repos" {
  description = "GitHub repos (owner/name) whose main branch may assume the build-evaluator deploy role."
  type        = list(string)
  default     = ["MartinSG98/computer-shop-build-eval"]
}

variable "api_domain_name" {
  description = "Custom domain for the API, e.g. api.msg-computers.com. Leave empty to use only the default API Gateway invoke URL."
  type        = string
  default     = ""
}

variable "site_domain_name" {
  description = "Custom domain for the frontend site, e.g. msg-computers.com. Leave empty to use only the default CloudFront URL."
  type        = string
  default     = ""
}

variable "hosted_zone_name" {
  description = "Route 53 public hosted zone the custom domains live in, e.g. msg-computers.com. Required when api_domain_name or site_domain_name is set."
  type        = string
  default     = ""
}

variable "api_throttle_rate_limit" {
  description = "Steady-state requests/sec cap across all API routes."
  type        = number
  default     = 20
}

variable "api_throttle_burst_limit" {
  description = "Max burst of concurrent requests for the API."
  type        = number
  default     = 40
}