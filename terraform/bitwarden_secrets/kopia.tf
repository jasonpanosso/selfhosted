locals {
  # One entry per Kopiur repository, each with its own password: a namespace
  # holding a single app, or an app in a namespace with a repository per app.
  # Removing an entry is blocked by prevent_destroy: retire a repository deliberately.
  kopia_repositories = toset([
    "thelounge",
    "rcon-web-admin",
    "bookboss",
    "tandoor",
    "jellyfin",
    "prowlarr",
    "qbittorrent",
    "qui",
    "radarr",
    "seerr",
    "sonarr",
    "upbrr",
    "sunlit-valley-cobblemon",
    "sunlit-valley",
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
