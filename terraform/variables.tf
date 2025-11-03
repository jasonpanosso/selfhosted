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

variable "bitwarden_access_token" {
  description = "Access token for Bitwarden Secrets"
  type        = string
  sensitive   = true
}

variable "bitwarden_organization_id" {
  description = "Bitwarden Organization ID"
  type        = string
}

variable "cloudflare_api_token" {
  description = "API token for Cloudflare"
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

variable "curseforge_api_key" {
  description = "Curseforge developer API key"
  type        = string
  sensitive   = true
}

variable "cluster_id" {
  description = "Kubernetes Cluster ID"
  type        = string
  sensitive   = true
}

variable "cluster_secret" {
  description = "Kubernetes cluster secret"
  type        = string
  sensitive   = true
}

variable "cluster_token" {
  description = "Kubernetes cluster token"
  type        = string
  sensitive   = true
}

variable "cluster_aggregator_ca_crt" {
  description = "Kubernetes cluster aggregator CA CRT"
  type        = string
  sensitive   = true
}

variable "cluster_aggregator_ca_key" {
  description = "Kubernetes cluster aggregator CA key"
  type        = string
  sensitive   = true
}

variable "cluster_secretbox_encryption_secret" {
  description = "Kubernetes cluster secretbox encryption secret"
  type        = string
  sensitive   = true
}

variable "cluster_service_account_key" {
  description = "Kubernetes cluster service account key"
  type        = string
  sensitive   = true
}

variable "cluster_etcd_ca_crt" {
  description = "Kubernetes cluster etcd CA CRT"
  type        = string
  sensitive   = true
}

variable "cluster_etcd_ca_key" {
  description = "Kubernetes cluster etcd CA key"
  type        = string
  sensitive   = true
}

variable "cluster_ca_crt" {
  description = "Kubernetes cluster CA CRT"
  type        = string
  sensitive   = true
}

variable "cluster_ca_key" {
  description = "Kubernetes cluster CA key"
  type        = string
  sensitive   = true
}

variable "machine_ca_crt" {
  description = "Kubernetes machine CA CRT"
  type        = string
  sensitive   = true
}

variable "machine_ca_key" {
  description = "Kubernetes machine CA key"
  type        = string
  sensitive   = true
}

variable "machine_token" {
  description = "Kubernetes machine token"
  type        = string
  sensitive   = true
}
