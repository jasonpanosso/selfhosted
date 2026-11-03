resource "random_password" "home_assistant_oidc_password" {
  length           = 30
  special          = true
  override_special = "!@#%&*()-_=+[]{}<>:"
}

resource "random_password" "home_assistant_oidc_salt" {
  length           = 8
  special          = true
  override_special = "!@#%&*()-_=+[]{}<>:"
}

resource "htpasswd_password" "home_assistant_oidc_hash" {
  password = random_password.home_assistant_oidc_password.result
  salt     = random_password.home_assistant_oidc_salt.result
}

resource "bitwarden-secrets_secret" "home_assistant_oidc_password" {
  key        = "HOME_ASSISTANT_OIDC_PASSWORD"
  value      = random_password.home_assistant_oidc_password.result
  project_id = bitwarden_project.this.id
  note       = "home assistant OIDC password"
}

resource "bitwarden-secrets_secret" "home_assistant_oidc_hash" {
  key        = "HOME_ASSISTANT_OIDC_HASH"
  value      = htpasswd_password.home_assistant_oidc_hash.sha512
  project_id = bitwarden_project.this.id
  note       = "home assistant OIDC SHA512 password hash"
}
