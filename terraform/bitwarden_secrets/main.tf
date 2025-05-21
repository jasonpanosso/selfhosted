resource "bitwarden_project" "this" {
  name            = var.project_name
  organization_id = var.organization_id
}

resource "bitwarden_secret" "cloudflare_api_token" {
  key        = "CLOUDFLARE_API_TOKEN"
  value      = var.cloudflare_api_token
  project_id = bitwarden_project.this.id
  note       = "API token for cloudflare"
}

resource "bitwarden_secret" "s3_access_key_id" {
  key        = "S3_ACCESS_KEY_ID"
  value      = var.s3_access_key_id
  project_id = bitwarden_project.this.id
  note       = "Access Key ID for S3 WAL Backup Bucket"
}

resource "bitwarden_secret" "s3_secret_access_key" {
  key        = "S3_SECRET_ACCESS_KEY"
  value      = var.s3_secret_access_key
  project_id = bitwarden_project.this.id
  note       = "Secret Access Key for S3 WAL Backup Bucket"
}
