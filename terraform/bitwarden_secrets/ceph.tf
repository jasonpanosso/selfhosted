resource "random_password" "ceph_admin_dashboard_password" {
  length  = 128
  special = true
}

resource "bitwarden_secret" "ceph_admin_dashboard_password" {
  key        = "CEPH_ADMIN_DASHBOARD_PASSWORD"
  value      = random_password.ceph_admin_dashboard_password.result
  project_id = bitwarden_project.this.id
  note       = "Admin password for Ceph management dashboard"
}
