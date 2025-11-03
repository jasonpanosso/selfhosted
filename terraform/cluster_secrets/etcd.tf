resource "bitwarden_secret" "cluster_etcd_ca_crt" {
  key        = "CLUSTER_ETCD_CA_CRT"
  value      = var.cluster_etcd_ca_crt
  project_id = bitwarden_project.this.id
  note       = "Cluster etcd CA CRT"
}

resource "bitwarden_secret" "cluster_etcd_ca_key" {
  key        = "CLUSTER_ETCD_CA_KEY"
  value      = var.cluster_etcd_ca_key
  project_id = bitwarden_project.this.id
  note       = "Cluster etcd CA key"
}
