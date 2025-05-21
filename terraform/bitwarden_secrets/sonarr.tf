resource "bitwarden_secret" "sonarr_db_username" {
  key        = "SONARR_DB_USERNAME"
  value      = "sonarr"
  project_id = bitwarden_project.this.id
  note       = "Postgres database username for the sonarr user"
}

resource "random_password" "sonarr_db_password" {
  length  = 128
  special = true
}

resource "bitwarden_secret" "sonarr_db_password" {
  key        = "SONARR_DB_PASSWORD"
  value      = random_password.sonarr_db_password.result
  project_id = bitwarden_project.this.id
  note       = "Postgres database password for the sonarr user"
}

resource "random_password" "sonarr_api_token" {
  length  = 32
  special = true
}

resource "bitwarden_secret" "sonarr_api_token" {
  key        = "SONARR_API_TOKEN"
  value      = random_password.sonarr_api_token.result
  project_id = bitwarden_project.this.id
  note       = "Sonarr API token"
}
