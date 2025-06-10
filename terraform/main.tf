module "spaces" {
  source  = "terraform-do-modules/spaces/digitalocean"
  version = "1.0.0"

  name       = var.spaces_name
  region     = var.spaces_region
  acl        = "private"
  versioning = true
}

resource "digitalocean_spaces_key" "this" {
  name = "${module.spaces.name}-key"

  grant {
    bucket     = module.spaces.name
    permission = "readwrite"
  }
}

module "bitwarden_secrets" {
  source       = "./bitwarden_secrets"
  project_name = "selfhosted_secrets"

  organization_id             = var.bitwarden_organization_id
  cloudflare_api_token        = var.cloudflare_api_token
  vpn_service_provider        = var.vpn_service_provider
  vpn_wireguard_addresses     = var.vpn_wireguard_addresses
  vpn_firewall_input_ports    = var.vpn_firewall_input_ports
  vpn_wireguard_private_key   = var.vpn_wireguard_private_key
  vpn_wireguard_preshared_key = var.vpn_wireguard_preshared_key

  s3_access_key_id     = digitalocean_spaces_key.this.access_key
  s3_secret_access_key = digitalocean_spaces_key.this.secret_key

  curseforge_api_token = var.curseforge_api_token

  # how can I generate this zz
  authelia_oidc_jwks_private_key = var.authelia_oidc_jwks_private_key

  smtp_username = var.smtp_username
  smtp_password = var.smtp_password

  pushover_user_key            = var.pushover_user_key
  pushover_api_token           = var.pushover_api_token
  healthchecksio_heartbeat_url = var.healthchecksio_heartbeat_url
}
