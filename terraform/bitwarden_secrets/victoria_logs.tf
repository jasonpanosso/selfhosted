resource "random_password" "victoria_logs_auth_key" {
  length  = 64
  special = false
}

resource "bitwarden-secrets_secret" "victoria_logs_auth_key" {
  key        = "VICTORIA_LOGS_AUTH_KEY"
  value      = random_password.victoria_logs_auth_key.result
  project_id = bitwarden_project.this.id
  note       = "VictoriaLogs authKey for admin and internal endpoints (partitions, force merge, etc.)"
}
