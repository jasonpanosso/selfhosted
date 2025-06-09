resource "random_password" "cross_seed_api_token" {
  length  = 128
  special = false
}

resource "bitwarden_secret" "cross_seed_api_token" {
  key        = "CROSS_SEED_API_TOKEN"
  value      = random_password.cross_seed_api_token.result
  project_id = bitwarden_project.this.id
  note       = "cross-seed api token"
}
