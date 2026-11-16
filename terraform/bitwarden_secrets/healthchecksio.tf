resource "bitwarden-secrets_secret" "healthchecksio_heartbeat_url" {
  key        = "HEALTHCHECKSIO_HEARTBEAT_URL"
  value      = var.healthchecksio_heartbeat_url
  project_id = bitwarden_project.this.id
  note       = "URL for healthchecks.io heartbeats(Alertmanager dead mans snitch)"
}

resource "bitwarden-secrets_secret" "healthchecksio_heartbeat_fail_url" {
  key        = "HEALTHCHECKSIO_HEARTBEAT_FAIL_URL"
  value      = "${var.healthchecksio_heartbeat_url}/fail"
  project_id = bitwarden_project.this.id
  note       = "healthchecks.io heartbeat failure signal (Alertmanager can't reach Pushover)"
}
