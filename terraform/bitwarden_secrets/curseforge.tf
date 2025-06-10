resource "bitwarden_secret" "curseforge_api_token" {
  key        = "CURSEFORGE_API_TOKEN"
  value      = var.curseforge_api_token
  project_id = bitwarden_project.this.id
  note       = "Curseforge API token"
}
