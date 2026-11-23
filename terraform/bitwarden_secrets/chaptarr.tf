resource "random_password" "chaptarr_api_token" {
  length  = 32
  special = true
}

resource "bitwarden-secrets_secret" "chaptarr_api_token" {
  key        = "CHAPTARR_API_TOKEN"
  value      = random_password.chaptarr_api_token.result
  project_id = bitwarden_project.this.id
  note       = "Chaptarr API token"
}
