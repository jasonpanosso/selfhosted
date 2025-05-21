resource "bitwarden_secret" "smtp_username" {
  key        = "SMTP_USERNAME"
  value      = var.smtp_username
  project_id = bitwarden_project.this.id
  note       = "SMTP username"
}

resource "bitwarden_secret" "smtp_password" {
  key        = "SMTP_PASSWORD"
  value      = var.smtp_password
  project_id = bitwarden_project.this.id
  note       = "SMTP password"
}
