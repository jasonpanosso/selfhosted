resource "random_password" "bookboss_encryption_secret" {
  length  = 64
  special = false
}

resource "bitwarden-secrets_secret" "bookboss_encryption_secret" {
  key        = "BOOKBOSS_ENCRYPTION_SECRET"
  value      = random_password.bookboss_encryption_secret.result
  project_id = bitwarden_project.this.id
  note       = "bookboss encryption secret"
}

resource "bitwarden-secrets_secret" "hardcover_api_key" {
  key        = "HARDCOVER_API_KEY"
  value      = var.hardcover_api_key
  project_id = bitwarden_project.this.id
  note       = "hardcover api key"
}

resource "random_password" "bookboss_oidc_password" {
  length           = 30
  special          = true
  override_special = "!@#%&*()-_=+[]{}<>:"
}

resource "random_password" "bookboss_oidc_salt" {
  length           = 8
  special          = true
  override_special = "!@#%&*()-_=+[]{}<>:"
}

resource "htpasswd_password" "bookboss_oidc_hash" {
  password = random_password.bookboss_oidc_password.result
  salt     = random_password.bookboss_oidc_salt.result
}

resource "bitwarden-secrets_secret" "bookboss_oidc_password" {
  key        = "BOOKBOSS_OIDC_PASSWORD"
  value      = random_password.bookboss_oidc_password.result
  project_id = bitwarden_project.this.id
  note       = "bookboss OIDC password"
}

resource "bitwarden-secrets_secret" "bookboss_oidc_hash" {
  key        = "BOOKBOSS_OIDC_HASH"
  value      = htpasswd_password.bookboss_oidc_hash.sha512
  project_id = bitwarden_project.this.id
  note       = "bookboss OIDC SHA512 password hash"
}
