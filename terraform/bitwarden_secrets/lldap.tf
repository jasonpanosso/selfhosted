resource "bitwarden_secret" "lldap_db_username" {
  key        = "LLDAP_DB_USERNAME"
  value      = "lldap"
  project_id = bitwarden_project.this.id
  note       = "Postgres database username for the lldap user"
}

resource "random_password" "lldap_db_password" {
  length  = 128
  special = true
}

resource "bitwarden_secret" "lldap_db_password" {
  key        = "LLDAP_DB_PASSWORD"
  value      = random_password.lldap_db_password.result
  project_id = bitwarden_project.this.id
  note       = "Postgres database password for the lldap user"
}

resource "random_password" "lldap_jwt_secret" {
  length  = 128
  special = true
}

resource "bitwarden_secret" "lldap_jwt_secret" {
  key        = "LLDAP_JWT_SECRET"
  value      = random_password.lldap_jwt_secret.result
  project_id = bitwarden_project.this.id
  note       = "JWT secret for lldap"
}

resource "random_password" "lldap_key_seed" {
  length  = 128
  special = true
}

resource "bitwarden_secret" "lldap_key_seed" {
  key        = "LLDAP_KEY_SEED"
  value      = random_password.lldap_key_seed.result
  project_id = bitwarden_project.this.id
  note       = "Key seed for lldap"
}

resource "random_password" "lldap_admin_password" {
  length  = 128
  special = true
}

resource "bitwarden_secret" "lldap_admin_password" {
  key        = "LLDAP_ADMIN_PASSWORD"
  value      = random_password.lldap_admin_password.result
  project_id = bitwarden_project.this.id
  note       = "Password for LLDAP admin user"
}
