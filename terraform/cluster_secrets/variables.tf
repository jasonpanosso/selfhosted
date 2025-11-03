variable "organization_id" {
  description = "Bitwarden Organization ID"
  type        = string
}

variable "project_name" {
  description = "Name of project to create"
  type        = string
}

variable "cluster_id" {
  description = "Kubernetes Cluster ID"
  type        = string
  sensitive   = true
}

variable "cluster_secret" {
  description = "Kubernetes cluster secret"
  type        = string
  sensitive   = true
}

variable "cluster_token" {
  description = "Kubernetes cluster token"
  type        = string
  sensitive   = true
}

variable "cluster_aggregator_ca_crt" {
  description = "Kubernetes cluster aggregator CA CRT"
  type        = string
  sensitive   = true
}

variable "cluster_aggregator_ca_key" {
  description = "Kubernetes cluster aggregator CA key"
  type        = string
  sensitive   = true
}

variable "cluster_secretbox_encryption_secret" {
  description = "Kubernetes cluster secretbox encryption secret"
  type        = string
  sensitive   = true
}

variable "cluster_service_account_key" {
  description = "Kubernetes cluster service account key"
  type        = string
  sensitive   = true
}

variable "cluster_etcd_ca_crt" {
  description = "Kubernetes cluster etcd CA CRT"
  type        = string
  sensitive   = true
}

variable "cluster_etcd_ca_key" {
  description = "Kubernetes cluster etcd CA key"
  type        = string
  sensitive   = true
}

variable "cluster_ca_crt" {
  description = "Kubernetes cluster CA CRT"
  type        = string
  sensitive   = true
}

variable "cluster_ca_key" {
  description = "Kubernetes cluster CA key"
  type        = string
  sensitive   = true
}

variable "machine_ca_crt" {
  description = "Kubernetes machine CA CRT"
  type        = string
  sensitive   = true
}

variable "machine_ca_key" {
  description = "Kubernetes machine CA key"
  type        = string
  sensitive   = true
}

variable "machine_token" {
  description = "Kubernetes machine token"
  type        = string
  sensitive   = true
}
