resource "random_password" "seasonpackarr_api_token" {
  length  = 32
  special = false
}

resource "bitwarden_secret" "seasonpackarr_api_token" {
  key        = "SEASONPACKARR_API_TOKEN"
  value      = random_password.seasonpackarr_api_token.result
  project_id = bitwarden_project.this.id
  note       = "Seasonpackarr API token"
}
