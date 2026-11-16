resource "random_password" "bgp_md5_password" {
  length  = 64
  special = false
}

resource "bitwarden-secrets_secret" "bgp_md5_password" {
  key        = "BGP_MD5_PASSWORD"
  value      = random_password.bgp_md5_password.result
  project_id = bitwarden_project.this.id
  note       = "TCP MD5 password for BGP between Cilium and router peer-group Kubernetes"
}
