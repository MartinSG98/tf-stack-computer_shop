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
  description = "Comma-separated CORS origins for the API (e.g. https://shop.example.com)."
  type        = string
  default     = ""
}

variable "github_deploy_repos" {
  description = "GitHub repos (owner/name) whose main branch may assume the deploy role."
  type        = list(string)
  default     = ["MartinSG98/computer-shop-backend"]
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