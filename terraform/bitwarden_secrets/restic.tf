resource "random_password" "restic_password" {
  length  = 128
  special = true
}

resource "bitwarden_secret" "restic_password" {
  key        = "RESTIC_PASSWORD"
  value      = random_password.restic_password.result
  project_id = bitwarden_project.this.id
  note       = "Restic encryption password"
}
