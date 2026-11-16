resource "bitwarden-secrets_secret" "mam_id" {
  key        = "MAM_ID"
  value      = var.mam_id
  project_id = bitwarden_project.this.id
  note       = "myanonamouse IP-locked dynamic seedbox session (mam_id); changing it re-seeds the seedbox CronJobs' cookie jar"
}
