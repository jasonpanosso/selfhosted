resource "random_password" "volsync_rgw_access_key_id" {
  length  = 128
  special = true
}

resource "bitwarden_secret" "volsync_rgw_access_key_id" {
  key        = "VOLSYNC_RGW_ACCESS_KEY_ID"
  value      = random_password.volsync_rgw_access_key_id.result
  project_id = bitwarden_project.this.id
  note       = "Access key ID for Volsync RGW user"
}

resource "random_password" "volsync_rgw_secret_access_key" {
  length  = 128
  special = true
}

resource "bitwarden_secret" "volsync_rgw_secret_access_key" {
  key        = "VOLSYNC_RGW_SECRET_ACCESS_KEY"
  value      = random_password.volsync_rgw_secret_access_key.result
  project_id = bitwarden_project.this.id
  note       = "Secret access key for Volsync RGW user"
}
