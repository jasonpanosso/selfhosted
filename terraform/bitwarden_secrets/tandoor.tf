resource "bitwarden-secrets_secret" "tandoor_db_username" {
  key        = "TANDOOR_DB_USERNAME"
  value      = "tandoor"
  project_id = bitwarden_project.this.id
  note       = "Postgres database username for the tandoor user"
}

resource "random_password" "tandoor_db_password" {
  length  = 128
  special = false
}

resource "bitwarden-secrets_secret" "tandoor_db_password" {
  key        = "TANDOOR_DB_PASSWORD"
  value      = random_password.tandoor_db_password.result
  project_id = bitwarden_project.this.id
  note       = "Postgres database password for the tandoor user"
}

resource "random_password" "tandoor_encryption_secret" {
  length  = 64
  special = false
}

resource "bitwarden-secrets_secret" "tandoor_encryption_secret" {
  key        = "TANDOOR_ENCRYPTION_SECRET"
  value      = random_password.tandoor_encryption_secret.result
  project_id = bitwarden_project.this.id
  note       = "tandoor encryption secret"
}
