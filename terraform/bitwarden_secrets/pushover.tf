resource "bitwarden_secret" "pushover_user_token" {
  key        = "PUSHOVER_USER_KEY"
  value      = var.pushover_user_key
  project_id = bitwarden_project.this.id
  note       = "User key for Pushover(push notifications)"
}

resource "bitwarden_secret" "pushover_api_token" {
  key        = "PUSHOVER_API_TOKEN"
  value      = var.pushover_api_token
  project_id = bitwarden_project.this.id
  note       = "API token for Pushover(push notifications)"
}
