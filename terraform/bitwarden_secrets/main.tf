resource "bitwarden_project" "this" {
  name            = var.project_name
  organization_id = var.organization_id
}

resource "bitwarden-secrets_secret" "cloudflare_api_token" {
  key        = "CLOUDFLARE_API_TOKEN"
  value      = var.cloudflare_api_token
  project_id = bitwarden_project.this.id
  note       = "Cloudflare API token for cert-manager DNS-01"
}

resource "bitwarden-secrets_secret" "cloudflare_external_dns_api_token" {
  key        = "CLOUDFLARE_EXTERNAL_DNS_API_TOKEN"
  value      = var.cloudflare_external_dns_api_token
  project_id = bitwarden_project.this.id
  note       = "Cloudflare API token for external-dns"
}
