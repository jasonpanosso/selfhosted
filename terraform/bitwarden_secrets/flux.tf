resource "random_password" "flux_github_webhook_token" {
  length  = 64
  special = false
}

resource "bitwarden_secret" "flux_github_webhook_token" {
  key        = "FLUX_GITHUB_WEBHOOK_TOKEN"
  value      = random_password.flux_github_webhook_token.result
  project_id = bitwarden_project.this.id
  note       = "Flux GitHub webhook API token"
}
