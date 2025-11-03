resource "bitwarden_secret" "machine_ca_crt" {
  key        = "MACHINE_CA_CRT"
  value      = var.machine_ca_crt
  project_id = bitwarden_project.this.id
  note       = "Machine CA CRT"
}

resource "bitwarden_secret" "machine_ca_key" {
  key        = "MACHINE_CA_KEY"
  value      = var.machine_ca_key
  project_id = bitwarden_project.this.id
  note       = "Machine CA key"
}

resource "bitwarden_secret" "machine_token" {
  key        = "MACHINE_TOKEN"
  value      = var.machine_token
  project_id = bitwarden_project.this.id
  note       = "Machine token"
}
