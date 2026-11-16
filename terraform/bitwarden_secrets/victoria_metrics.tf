resource "random_password" "vmsingle_auth_key" {
  length  = 64
  special = false
}

resource "bitwarden-secrets_secret" "vmsingle_auth_key" {
  key        = "VMSINGLE_AUTH_KEY"
  value      = random_password.vmsingle_auth_key.result
  project_id = bitwarden_project.this.id
  note       = "VictoriaMetrics single authKey for admin and internal endpoints (delete, snapshot, force merge, etc.)"
}
