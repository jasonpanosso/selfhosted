resource "bitwarden_secret" "jellyseerr_db_username" {
  key        = "JELLYSEERR_DB_USERNAME"
  value      = "jellyseerr"
  project_id = bitwarden_project.this.id
  note       = "Postgres database username for the jellyseerr user"
}

resource "random_password" "jellyseerr_db_password" {
  length  = 128
  special = true
}

resource "bitwarden_secret" "jellyseerr_db_password" {
  key        = "JELLYSEERR_DB_PASSWORD"
  value      = random_password.jellyseerr_db_password.result
  project_id = bitwarden_project.this.id
  note       = "Postgres database password for the jellyseerr user"
}

resource "random_password" "jellyseerr_api_token" {
  length  = 32
  special = true
}

resource "bitwarden_secret" "jellyseerr_api_token" {
  key        = "JELLYSEERR_API_TOKEN"
  value      = random_password.jellyseerr_api_token.result
  project_id = bitwarden_project.this.id
  note       = "Jellyseerr API token"
}
