resource "bitwarden-secrets_secret" "vpn_firewall_input_ports" {
  key        = "VPN_FIREWALL_INPUT_PORTS"
  value      = var.vpn_firewall_input_ports
  project_id = bitwarden_project.this.id
  note       = "VPN opened firewall ports"
}
