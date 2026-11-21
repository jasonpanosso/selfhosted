variable "organization_id" {
  description = "Bitwarden Organization ID"
  type        = string
}

variable "project_name" {
  description = "Name of project to create"
  type        = string
}

variable "cloudflare_api_token" {
  description = "Cloudflare API token for cert-manager DNS-01"
  type        = string
  sensitive   = true
}

variable "cloudflare_external_dns_api_token" {
  description = "Cloudflare API token for external-dns"
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

variable "mam_id" {
  description = "myanonamouse IP-locked dynamic seedbox session cookie value (mam_id)"
  type        = string
  sensitive   = true
}

variable "resend_api_key" {
  description = "Resend API key (sending access), used as the SMTP password"
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

variable "theintrodb_api_key" {
  description = "TheIntroDB API key for silo's theintrodb plugin"
  type        = string
  sensitive   = true
}

variable "openrouter_api_key" {
  description = "OpenRouter API key for silo's embeddings provider"
  type        = string
  sensitive   = true
}
