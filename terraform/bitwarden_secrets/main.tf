resource "bitwarden_project" "this" {
  name            = var.project_name
  organization_id = var.organization_id
}

resource "bitwarden-secrets_secret" "cloudflare_api_token" {
  key        = "CLOUDFLARE_API_TOKEN"
  value      = var.cloudflare_api_token
  project_id = bitwarden_project.this.id
  note       = "API token for cloudflare"
}
