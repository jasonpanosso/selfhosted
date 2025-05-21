resource "bitwarden_secret" "jellyfin_db_username" {
  key        = "JELLYFIN_DB_USERNAME"
  value      = "jellyfin"
  project_id = bitwarden_project.this.id
  note       = "Postgres database username for the jellyfin user"
}

resource "random_password" "jellyfin_db_password" {
  length  = 128
  special = true
}

resource "bitwarden_secret" "jellyfin_db_password" {
  key        = "JELLYFIN_DB_PASSWORD"
  value      = random_password.jellyfin_db_password.result
  project_id = bitwarden_project.this.id
  note       = "Postgres database password for the jellyfin user"
}

