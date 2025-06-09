resource "bitwarden_secret" "autobrr_db_username" {
  key        = "AUTOBRR_DB_USERNAME"
  value      = "autobrr"
  project_id = bitwarden_project.this.id
  note       = "Postgres database username for the autobrr user"
}

resource "random_password" "autobrr_db_password" {
  length  = 128
  special = true
}

resource "bitwarden_secret" "autobrr_db_password" {
  key        = "AUTOBRR_DB_PASSWORD"
  value      = random_password.autobrr_db_password.result
  project_id = bitwarden_project.this.id
  note       = "Postgres database password for the autobrr user"
}

resource "random_password" "autobrr_session_secret" {
  length  = 64
  special = false
}

resource "bitwarden_secret" "autobrr_session_secret" {
  key        = "AUTOBRR_SESSION_SECRET"
  value      = random_password.autobrr_session_secret.result
  project_id = bitwarden_project.this.id
  note       = "Autobrr session secret"
}

resource "random_password" "autobrr_oidc_password" {
  length           = 30
  special          = true
  override_special = "!@#%&*()-_=+[]{}<>:"
}

resource "random_password" "autobrr_oidc_salt" {
  length           = 8
  special          = true
  override_special = "!@#%&*()-_=+[]{}<>:"
}

resource "htpasswd_password" "autobrr_oidc_hash" {
  password = random_password.autobrr_oidc_password.result
  salt     = random_password.autobrr_oidc_salt.result
}

resource "bitwarden_secret" "autobrr_oidc_password" {
  key        = "AUTOBRR_OIDC_PASSWORD"
  value      = random_password.autobrr_oidc_password.result
  project_id = bitwarden_project.this.id
  note       = "Autobrr OIDC password"
}

resource "bitwarden_secret" "autobrr_oidc_hash" {
  key        = "AUTOBRR_OIDC_HASH"
  value      = htpasswd_password.autobrr_oidc_hash.sha512
  project_id = bitwarden_project.this.id
  note       = "Autobrr OIDC SHA512 password hash"
}
