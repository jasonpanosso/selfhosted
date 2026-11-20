resource "bitwarden-secrets_secret" "silo_db_username" {
  key        = "SILO_DB_USERNAME"
  value      = "silo"
  project_id = bitwarden_project.this.id
  note       = "Postgres database username for the silo user"
}

# no special characters, it's interpolated into silo's DATABASE_URL
resource "random_password" "silo_db_password" {
  length  = 128
  special = false
}

resource "bitwarden-secrets_secret" "silo_db_password" {
  key        = "SILO_DB_PASSWORD"
  value      = random_password.silo_db_password.result
  project_id = bitwarden_project.this.id
  note       = "Postgres database password for the silo user"
}

# no special characters, it's interpolated into silo's REDIS_URL
resource "random_password" "silo_redis_password" {
  length  = 64
  special = false
}

resource "bitwarden-secrets_secret" "silo_redis_password" {
  key        = "SILO_REDIS_PASSWORD"
  value      = random_password.silo_redis_password.result
  project_id = bitwarden_project.this.id
  note       = "Dragonfly password for silo's event bus"
}

# currently imported, keys must be generated in Silo UI
resource "random_password" "silo_node_key" {
  length = 50

  lifecycle {
    # a replacement would generate a key silo rejects
    prevent_destroy = true
  }
}

resource "bitwarden-secrets_secret" "silo_node_key" {
  key        = "SILO_NODE_KEY"
  value      = random_password.silo_node_key.result
  project_id = bitwarden_project.this.id
  note       = "silo transcode node key; reissuing it in silo invalidates this one (drain the node first)"
}

# encrypts plugin configs (OIDC client secret) and other secrets at rest.
resource "random_password" "silo_secret_key" {
  length  = 64
  special = false
}

resource "bitwarden-secrets_secret" "silo_secret_key" {
  key        = "SILO_SECRET_KEY"
  value      = random_password.silo_secret_key.result
  project_id = bitwarden_project.this.id
  note       = "silo SECRET_KEY, master key for at-rest credential encryption"
}

resource "random_password" "silo_oidc_password" {
  length           = 30
  special          = true
  override_special = "!@#%&*()-_=+[]{}<>:"
}

resource "random_password" "silo_oidc_salt" {
  length  = 8
  special = false
}

resource "htpasswd_password" "silo_oidc_hash" {
  password = random_password.silo_oidc_password.result
  salt     = random_password.silo_oidc_salt.result
}

resource "bitwarden-secrets_secret" "silo_oidc_password" {
  key        = "SILO_OIDC_PASSWORD"
  value      = random_password.silo_oidc_password.result
  project_id = bitwarden_project.this.id
  note       = "silo OIDC client secret, mounted as a file for silo's plugins.yaml"
}

resource "bitwarden-secrets_secret" "silo_oidc_hash" {
  key        = "SILO_OIDC_HASH"
  value      = htpasswd_password.silo_oidc_hash.sha512
  project_id = bitwarden_project.this.id
  note       = "silo OIDC SHA512 password hash"
}
