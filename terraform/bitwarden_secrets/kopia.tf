locals {
  # Namespaces with a Kopiur Repository; each gets its own repository password.
  # Removing an entry is blocked by prevent_destroy: retire a repository deliberately.
  kopia_repositories = toset([
    "thelounge",
    "rcon-web-admin",
    "bookboss",
    "tandoor",
  ])
}

resource "random_password" "kopia_password" {
  for_each = local.kopia_repositories

  length  = 64
  special = false

  lifecycle {
    prevent_destroy = true
  }
}

resource "bitwarden-secrets_secret" "kopia_password" {
  for_each = local.kopia_repositories

  key        = "KOPIA_PASSWORD_${upper(replace(each.key, "-", "_"))}"
  value      = random_password.kopia_password[each.key].result
  project_id = bitwarden_project.this.id
  note       = "Kopia repository encryption password for the ${each.key} namespace"

  lifecycle {
    prevent_destroy = true
  }
}
