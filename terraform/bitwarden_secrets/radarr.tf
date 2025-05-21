resource "bitwarden_secret" "radarr_db_username" {
  key        = "RADARR_DB_USERNAME"
  value      = "radarr"
  project_id = bitwarden_project.this.id
  note       = "Postgres database username for the radarr user"
}

resource "random_password" "radarr_db_password" {
  length  = 128
  special = true
}

resource "bitwarden_secret" "radarr_db_password" {
  key        = "RADARR_DB_PASSWORD"
  value      = random_password.radarr_db_password.result
  project_id = bitwarden_project.this.id
  note       = "Postgres database password for the radarr user"
}

resource "random_password" "radarr_api_token" {
  length  = 32
  special = true
}

resource "bitwarden_secret" "radarr_api_token" {
  key        = "RADARR_API_TOKEN"
  value      = random_password.radarr_api_token.result
  project_id = bitwarden_project.this.id
  note       = "Radarr API token"
}
