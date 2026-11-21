resource "bitwarden-secrets_secret" "resend_api_key" {
  key        = "RESEND_API_KEY"
  value      = var.resend_api_key
  project_id = bitwarden_project.this.id
  note       = "Resend API key (sending access), the SMTP password for authelia, lldap and silo"
}
