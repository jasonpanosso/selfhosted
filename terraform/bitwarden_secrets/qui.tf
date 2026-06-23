resource "bitwarden-secrets_secret" "qui_db_username" {
  key        = "QUI_DB_USERNAME"
  value      = "qui"
  project_id = bitwarden_project.this.id
  note       = "Postgres database username for the qui user"
}

resource "random_password" "qui_db_password" {
  length  = 128
  special = true
}

resource "bitwarden-secrets_secret" "qui_db_password" {
  key        = "QUI_DB_PASSWORD"
  value      = random_password.qui_db_password.result
  project_id = bitwarden_project.this.id
  note       = "Postgres database password for the qui user"
}

resource "random_password" "qui_session_secret" {
  length  = 64
  special = false
}

resource "bitwarden-secrets_secret" "qui_session_secret" {
  key        = "QUI_SESSION_SECRET"
  value      = random_password.qui_session_secret.result
  project_id = bitwarden_project.this.id
  note       = "qui session secret"
}

resource "random_password" "qui_oidc_password" {
  length           = 30
  special          = true
  override_special = "!@#%&*()-_=+[]{}<>:"
}

resource "random_password" "qui_oidc_salt" {
  length           = 8
  special          = true
  override_special = "!@#%&*()-_=+[]{}<>:"
}

resource "htpasswd_password" "qui_oidc_hash" {
  password = random_password.qui_oidc_password.result
  salt     = random_password.qui_oidc_salt.result
}

resource "bitwarden-secrets_secret" "qui_oidc_password" {
  key        = "QUI_OIDC_PASSWORD"
  value      = random_password.qui_oidc_password.result
  project_id = bitwarden_project.this.id
  note       = "qui OIDC password"
}

resource "bitwarden-secrets_secret" "qui_oidc_hash" {
  key        = "QUI_OIDC_HASH"
  value      = htpasswd_password.qui_oidc_hash.sha512
  project_id = bitwarden_project.this.id
  note       = "qui OIDC SHA512 password hash"
}
