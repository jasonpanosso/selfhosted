resource "bitwarden_secret" "cluster_id" {
  key        = "CLUSTER_ID"
  value      = var.cluster_id
  project_id = bitwarden_project.this.id
  note       = "Cluster ID"
}

resource "bitwarden_secret" "cluster_secret" {
  key        = "CLUSTER_SECRET"
  value      = var.cluster_secret
  project_id = bitwarden_project.this.id
  note       = "Cluster secret"
}

resource "bitwarden_secret" "cluster_token" {
  key        = "CLUSTER_TOKEN"
  value      = var.cluster_token
  project_id = bitwarden_project.this.id
  note       = "Cluster token"
}

resource "bitwarden_secret" "cluster_ca_crt" {
  key        = "CLUSTER_CA_CRT"
  value      = var.cluster_ca_crt
  project_id = bitwarden_project.this.id
  note       = "Cluster CA CRT"
}

resource "bitwarden_secret" "cluster_ca_key" {
  key        = "CLUSTER_CA_KEY"
  value      = var.cluster_ca_key
  project_id = bitwarden_project.this.id
  note       = "Cluster CA key"
}

resource "bitwarden_secret" "cluster_aggregator_ca_crt" {
  key        = "CLUSTER_AGGREGATOR_CA_CRT"
  value      = var.cluster_aggregator_ca_crt
  project_id = bitwarden_project.this.id
  note       = "Cluster Aggregator CA CRT"
}

resource "bitwarden_secret" "cluster_aggregator_ca_key" {
  key        = "CLUSTER_AGGREGATOR_CA_KEY"
  value      = var.cluster_aggregator_ca_key
  project_id = bitwarden_project.this.id
  note       = "Cluster Aggregator CA key"
}

resource "bitwarden_secret" "cluster_secretbox_encryption_secret" {
  key        = "CLUSTER_SECRETBOX_ENCRYPTION_SECRET"
  value      = var.cluster_secretbox_encryption_secret
  project_id = bitwarden_project.this.id
  note       = "Cluster secretbox encryption secret"
}

resource "bitwarden_secret" "cluster_service_account_key" {
  key        = "CLUSTER_SERVICE_ACCOUNT_KEY"
  value      = var.cluster_service_account_key
  project_id = bitwarden_project.this.id
  note       = "Cluster service account key"
}
