resource "random_password" "crowdsec_lapi_token" {
  length  = 64
  special = false
}

resource "bitwarden_secret" "crowdsec_lapi_token" {
  key        = "CROWDSEC_LAPI_TOKEN"
  value      = random_password.crowdsec_lapi_token.result
  project_id = bitwarden_project.this.id
  note       = "Crowdsec local api token"
}

resource "random_password" "crowdsec_registration_token" {
  length  = 64
  special = false
}

resource "bitwarden_secret" "crowdsec_registration_token" {
  key        = "CROWDSEC_REGISTRATION_TOKEN"
  value      = random_password.crowdsec_registration_token.result
  project_id = bitwarden_project.this.id
  note       = "Crowdsec registration api token"
}

resource "random_password" "crowdsec_bouncer_key_traefik" {
  length  = 64
  special = false
}

resource "bitwarden_secret" "crowdsec_bouncer_key_traefik" {
  key        = "CROWDSEC_BOUNCER_KEY_TRAEFIK"
  value      = random_password.crowdsec_bouncer_key_traefik.result
  project_id = bitwarden_project.this.id
  note       = "Crowdsec API key for Traefik bouncer"
}

resource "bitwarden_secret" "crowdsec_db_username" {
  key        = "CROWDSEC_DB_USERNAME"
  value      = "crowdsec"
  project_id = bitwarden_project.this.id
  note       = "Postgres database username for the crowdsec user"
}

resource "random_password" "crowdsec_db_password" {
  length  = 128
  special = true
}

resource "bitwarden_secret" "crowdsec_db_password" {
  key        = "CROWDSEC_DB_PASSWORD"
  value      = random_password.crowdsec_db_password.result
  project_id = bitwarden_project.this.id
  note       = "Postgres database password for the crowdsec user"
}
