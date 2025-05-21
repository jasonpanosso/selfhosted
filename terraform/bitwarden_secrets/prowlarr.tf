resource "bitwarden_secret" "prowlarr_db_username" {
  key        = "PROWLARR_DB_USERNAME"
  value      = "prowlarr"
  project_id = bitwarden_project.this.id
  note       = "Postgres database username for the prowlarr user"
}

resource "random_password" "prowlarr_db_password" {
  length  = 128
  special = true
}

resource "bitwarden_secret" "prowlarr_db_password" {
  key        = "PROWLARR_DB_PASSWORD"
  value      = random_password.prowlarr_db_password.result
  project_id = bitwarden_project.this.id
  note       = "Postgres database password for the prowlarr user"
}

resource "random_password" "prowlarr_api_token" {
  length  = 32
  special = true
}

resource "bitwarden_secret" "prowlarr_api_token" {
  key        = "PROWLARR_API_TOKEN"
  value      = random_password.prowlarr_api_token.result
  project_id = bitwarden_project.this.id
  note       = "Prowlarr API token"
}
