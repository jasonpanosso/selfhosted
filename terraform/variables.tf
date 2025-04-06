variable "digitalocean_token" {
  description = "DigitalOcean API token with permissions to manage Spaces"
  type        = string
  sensitive   = true
}

variable "digitalocean_spaces_access_id" {
  description = "DigitalOcean Spaces access ID"
  type        = string
  sensitive   = true
}

variable "digitalocean_spaces_secret_key" {
  description = "DigitalOcean Spaces secret key"
  type        = string
  sensitive   = true

}

variable "spaces_name" {
  description = "The name for the DigitalOcean Space"
  type        = string
}

variable "spaces_region" {
  description = "The region where the DigitalOcean Space will be created"
  type        = string
  default     = "nyc3"
}
