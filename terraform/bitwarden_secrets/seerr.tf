resource "bitwarden-secrets_secret" "seerr_db_username" {
  key        = "SEERR_DB_USERNAME"
  value      = "seerr"
  project_id = bitwarden_project.this.id
  note       = "Postgres database username for the seerr user"
}

resource "random_password" "seerr_db_password" {
  length  = 128
  special = true
}

resource "bitwarden-secrets_secret" "seerr_db_password" {
  key        = "SEERR_DB_PASSWORD"
  value      = random_password.seerr_db_password.result
  project_id = bitwarden_project.this.id
  note       = "Postgres database password for the seerr user"
}

resource "random_password" "seerr_api_token" {
  length  = 32
  special = true
}

resource "bitwarden-secrets_secret" "seerr_api_token" {
  key        = "SEERR_API_TOKEN"
  value      = random_password.seerr_api_token.result
  project_id = bitwarden_project.this.id
  note       = "Seerr API token"
}
