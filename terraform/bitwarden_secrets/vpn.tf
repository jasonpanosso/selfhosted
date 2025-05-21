resource "bitwarden_secret" "vpn_wireguard_private_key" {
  key        = "VPN_WIREGUARD_PRIVATE_KEY"
  value      = var.vpn_wireguard_private_key
  project_id = bitwarden_project.this.id
  note       = "Wireguard private key"
}

resource "bitwarden_secret" "vpn_wireguard_addresses" {
  key        = "VPN_WIREGUARD_ADDRESSES"
  value      = var.vpn_wireguard_addresses
  project_id = bitwarden_project.this.id
  note       = "Wireguard ip addresses"
}

resource "bitwarden_secret" "vpn_wireguard_preshared_key" {
  key        = "VPN_WIREGUARD_PRESHARED_KEY"
  value      = var.vpn_wireguard_preshared_key
  project_id = bitwarden_project.this.id
  note       = "Wireguard preshared key"
}

resource "bitwarden_secret" "vpn_service_provider" {
  key        = "VPN_SERVICE_PROVIDER"
  value      = var.vpn_service_provider
  project_id = bitwarden_project.this.id
  note       = "VPN service provider"
}

resource "bitwarden_secret" "vpn_firewall_input_ports" {
  key        = "VPN_FIREWALL_INPUT_PORTS"
  value      = var.vpn_firewall_input_ports
  project_id = bitwarden_project.this.id
  note       = "VPN opened firewall ports"
}
