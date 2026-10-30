resource "bitwarden-secrets_secret" "b2_cnpg_access_key_id" {
  key        = "B2_CNPG_ACCESS_KEY_ID"
  value      = var.b2_cnpg_access_key_id
  project_id = bitwarden_project.this.id
  note       = "B2 key ID for CNPG backups, scoped to cnpg-backups/, no deleteFiles"
}

resource "bitwarden-secrets_secret" "b2_cnpg_secret_access_key" {
  key        = "B2_CNPG_SECRET_ACCESS_KEY"
  value      = var.b2_cnpg_secret_access_key
  project_id = bitwarden_project.this.id
  note       = "B2 key for CNPG backups, scoped to cnpg-backups/, no deleteFiles"
}

resource "bitwarden-secrets_secret" "b2_talos_backup_access_key_id" {
  key        = "B2_TALOS_BACKUP_ACCESS_KEY_ID"
  value      = var.b2_talos_backup_access_key_id
  project_id = bitwarden_project.this.id
  note       = "B2 key ID for talos-backup, scoped to talos-backup/, no deleteFiles"
}

resource "bitwarden-secrets_secret" "b2_talos_backup_secret_access_key" {
  key        = "B2_TALOS_BACKUP_SECRET_ACCESS_KEY"
  value      = var.b2_talos_backup_secret_access_key
  project_id = bitwarden_project.this.id
  note       = "B2 key for talos-backup, scoped to talos-backup/, no deleteFiles"
}
