variable "domain_name" {
  type        = string
  description = "The domain you want to verify for SES."
}

variable "aws_region" {
  type        = string
  description = "AWS region to use for SES."
  default     = "us-east-1"
}

variable "cloudflare_api_token" {
  type        = string
  description = "API token for Cloudflare with DNS edit permissions."
  sensitive   = true
}

variable "aws_access_key" {
  description = "Access key for AWS"
  type        = string
  sensitive   = true
}

variable "aws_secret_key" {
  description = "Secret key for AWS"
  type        = string
  sensitive   = true
}
