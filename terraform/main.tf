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

  # how can I generate this zz
  authelia_oidc_jwks_private_key = var.authelia_oidc_jwks_private_key

  smtp_username = var.smtp_username
  smtp_password = var.smtp_password

  pushover_user_key            = var.pushover_user_key
  pushover_api_token           = var.pushover_api_token
  healthchecksio_heartbeat_url = var.healthchecksio_heartbeat_url
  curseforge_api_key           = var.curseforge_api_key
}

module "cluster_secrets" {
  source          = "./cluster_secrets"
  project_name    = "cluster_secrets"
  organization_id = var.bitwarden_organization_id

  cluster_id                          = var.cluster_id
  cluster_token                       = var.cluster_token
  cluster_secret                      = var.cluster_secret
  cluster_ca_crt                      = var.cluster_ca_crt
  cluster_ca_key                      = var.cluster_ca_key
  cluster_etcd_ca_crt                 = var.cluster_etcd_ca_crt
  cluster_etcd_ca_key                 = var.cluster_etcd_ca_key
  cluster_aggregator_ca_crt           = var.cluster_aggregator_ca_crt
  cluster_aggregator_ca_key           = var.cluster_aggregator_ca_key
  cluster_service_account_key         = var.cluster_service_account_key
  cluster_secretbox_encryption_secret = var.cluster_secretbox_encryption_secret

  machine_token  = var.machine_token
  machine_ca_crt = var.machine_ca_crt
  machine_ca_key = var.machine_ca_key
}
