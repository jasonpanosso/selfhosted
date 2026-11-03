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

variable "b2_bucket_id" {
  description = "ID of the B2 backup bucket, for the per-repository Kopiur keys"
  type        = string
}

variable "b2_cnpg_access_key_id" {
  description = "B2 application key ID for CNPG backups (cnpg-backups/)"
  type        = string
  sensitive   = true
}

variable "b2_cnpg_secret_access_key" {
  description = "B2 application key for CNPG backups (cnpg-backups/)"
  type        = string
  sensitive   = true
}

variable "b2_talos_backup_access_key_id" {
  description = "B2 application key ID for talos-backup (talos-backup/)"
  type        = string
  sensitive   = true
}

variable "b2_talos_backup_secret_access_key" {
  description = "B2 application key for talos-backup (talos-backup/)"
  type        = string
  sensitive   = true
}

variable "vpn_firewall_input_ports" {
  description = "Comma-delimited list of opened firewall ports (e.g. \"51820,1194\")"
  type        = string
  sensitive   = true
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

variable "hardcover_api_key" {
  description = "API token for Hardcover"
  type        = string
  sensitive   = true
}
