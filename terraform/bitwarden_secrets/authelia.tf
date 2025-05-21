resource "bitwarden_secret" "authelia_db_username" {
  key        = "AUTHELIA_DB_USERNAME"
  value      = "authelia"
  project_id = bitwarden_project.this.id
  note       = "Postgres database username for the authelia user"
}

resource "random_password" "authelia_db_password" {
  length  = 128
  special = true
}

resource "bitwarden_secret" "authelia_db_password" {
  key        = "AUTHELIA_DB_PASSWORD"
  value      = random_password.authelia_db_password.result
  project_id = bitwarden_project.this.id
  note       = "Postgres database password for the authelia user"
}

resource "random_password" "authelia_jwt_token" {
  length  = 128
  special = true
}

resource "bitwarden_secret" "authelia_jwt_token" {
  key        = "AUTHELIA_JWT_TOKEN"
  value      = random_password.authelia_jwt_token.result
  project_id = bitwarden_project.this.id
  note       = "JWT token for authelia"
}

resource "random_password" "authelia_session_key" {
  length  = 128
  special = true
}

resource "bitwarden_secret" "authelia_session_key" {
  key        = "AUTHELIA_SESSION_KEY"
  value      = random_password.authelia_session_key.result
  project_id = bitwarden_project.this.id
  note       = "Session key for authelia"
}

resource "random_password" "authelia_encryption_key" {
  length  = 128
  special = true
}

resource "bitwarden_secret" "authelia_encryption_key" {
  key        = "AUTHELIA_ENCRYPTION_KEY"
  value      = random_password.authelia_encryption_key.result
  project_id = bitwarden_project.this.id
  note       = "Encryption key for authelia"
}

resource "random_password" "authelia_oidc_hmac_secret" {
  length  = 128
  special = true
}

resource "bitwarden_secret" "authelia_oidc_hmac_secret" {
  key        = "AUTHELIA_OIDC_HMAC_SECRET"
  value      = random_password.authelia_oidc_hmac_secret.result
  project_id = bitwarden_project.this.id
  note       = "OIDC HMAC secret for authelia"
}

resource "bitwarden_secret" "authelia_oidc_test_secret" {
  key        = "AUTHELIA_OIDC_TEST_SECRET"
  value      = var.authelia_oidc_test_secret
  project_id = bitwarden_project.this.id
  note       = "OIDC test secret for authelia"
}

resource "random_password" "redis_password" {
  length  = 32
  special = true
}

resource "bitwarden_secret" "redis_password" {
  key        = "REDIS_PASSWORD"
  value      = random_password.redis_password.result
  project_id = bitwarden_project.this.id
  note       = "Redis backend password for authelia"
}

resource "bitwarden_secret" "authelia_oidc_jwks_private_key" {
  key        = "AUTHELIA_OIDC_JWKS_PRIVATE_KEY"
  value      = var.authelia_oidc_jwks_private_key
  project_id = bitwarden_project.this.id
  note       = "JWKS private key for Authelia OIDC"
}
