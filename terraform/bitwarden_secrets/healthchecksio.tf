resource "bitwarden_secret" "healthchecksio_heartbeat_url" {
  key        = "HEALTHCHECKSIO_HEARTBEAT_URL"
  value      = var.healthchecksio_heartbeat_url
  project_id = bitwarden_project.this.id
  note       = "URL for healthchecks.io heartbeats(Alertmanager dead mans snitch)"
}
