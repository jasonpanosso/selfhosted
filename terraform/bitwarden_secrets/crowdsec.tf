resource "random_password" "crowdsec_lapi_token" {
  length  = 64
  special = true
}

resource "bitwarden_secret" "crowdsec_lapi_token" {
  key        = "CROWDSEC_LAPI_TOKEN"
  value      = random_password.crowdsec_lapi_token.result
  project_id = bitwarden_project.this.id
  note       = "Crowdsec local api token"
}

resource "random_password" "crowdsec_registration_token" {
  length  = 64
  special = true
}

resource "bitwarden_secret" "crowdsec_registration_token" {
  key        = "CROWDSEC_REGISTRATION_TOKEN"
  value      = random_password.crowdsec_registration_token.result
  project_id = bitwarden_project.this.id
  note       = "Crowdsec registration api token"
}
