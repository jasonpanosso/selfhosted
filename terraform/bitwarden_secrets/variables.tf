variable "organization_id" {
  description = "Bitwarden Organization ID"
  type        = string
}

variable "project_name" {
  description = "Name of project to create"
  type        = string
}

variable "cloudflare_api_token" {
  description = "API token for Cloudflare"
  type        = string
  sensitive   = true
}

variable "s3_access_key_id" {
  description = "Access key ID for S3 Bucket"
  type        = string
  sensitive   = true
}

variable "s3_secret_access_key" {
  description = "Secret access key for S3 Bucket"
  type        = string
  sensitive   = true
}

variable "vpn_wireguard_private_key" {
  description = "WireGuard private key"
  type        = string
  sensitive   = true
}

variable "vpn_wireguard_addresses" {
  description = "Comma-delimited list of WireGuard peer IP addresses (e.g. \"10.0.0.2/32,10.0.0.3/32\")"
  type        = string
  sensitive   = true
}

variable "vpn_wireguard_preshared_key" {
  description = "WireGuard preshared key"
  type        = string
  sensitive   = true
}

variable "vpn_firewall_input_ports" {
  description = "Comma-delimited list of opened firewall ports (e.g. \"51820,1194\")"
  type        = string
  sensitive   = true
}

variable "vpn_service_provider" {
  description = "Identifier for the VPN service provider (e.g. \"privateinternetaccess\", \"nordvpn\")"
  type        = string
}

variable "smtp_username" {
  description = "SMTP username"
  type        = string
  sensitive   = true
}

variable "smtp_password" {
  description = "SMTP password"
  type        = string
  sensitive   = true
}

variable "authelia_oidc_jwks_private_key" {
  description = "JWKS private key for Authelia OIDC"
  type        = string
  sensitive   = true
}

variable "pushover_user_key" {
  description = "User key for Pushover(push notifications)"
  type        = string
  sensitive   = true
}

variable "pushover_api_token" {
  description = "API token for Pushover(push notifications)"
  type        = string
  sensitive   = true
}

variable "healthchecksio_heartbeat_url" {
  description = "URL for healthchecks.io heartbeats(Alertmanager dead mans snitch)"
  type        = string
  sensitive   = true
}

variable "curseforge_api_token" {
  description = "API token for curseforge"
  type        = string
  sensitive   = true
}
