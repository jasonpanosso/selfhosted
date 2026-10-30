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
    "radarr",
    "seerr",
    "sonarr",
    "upbrr",
    "filebrowser",
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

# scoped key per repository
resource "b2_application_key" "kopiur" {
  for_each = local.kopia_repositories

  key_name     = "kopiur-${each.key}"
  capabilities = ["listBuckets", "listFiles", "readFiles", "writeFiles"]
  bucket_ids   = [var.b2_bucket_id]
  name_prefix  = "kopiur/${each.key}/"
}

resource "bitwarden-secrets_secret" "kopiur_b2_access_key_id" {
  for_each = local.kopia_repositories

  key        = "B2_KOPIUR_${upper(replace(each.key, "-", "_"))}_ACCESS_KEY_ID"
  value      = b2_application_key.kopiur[each.key].application_key_id
  project_id = bitwarden_project.this.id
  note       = "B2 key ID for the ${each.key} Kopiur offsite repository, scoped to kopiur/${each.key}/"
}

resource "bitwarden-secrets_secret" "kopiur_b2_secret_access_key" {
  for_each = local.kopia_repositories

  key        = "B2_KOPIUR_${upper(replace(each.key, "-", "_"))}_SECRET_ACCESS_KEY"
  value      = b2_application_key.kopiur[each.key].application_key
  project_id = bitwarden_project.this.id
  note       = "B2 key for the ${each.key} Kopiur offsite repository, scoped to kopiur/${each.key}/"
}
