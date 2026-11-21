resource "bitwarden-secrets_secret" "silo_db_username" {
  key        = "SILO_DB_USERNAME"
  value      = "silo"
  project_id = bitwarden_project.this.id
  note       = "Postgres database username for the silo user"
}

# no special characters, it's interpolated into silo's DATABASE_URL
resource "random_password" "silo_db_password" {
  length  = 128
  special = false
}

resource "bitwarden-secrets_secret" "silo_db_password" {
  key        = "SILO_DB_PASSWORD"
  value      = random_password.silo_db_password.result
  project_id = bitwarden_project.this.id
  note       = "Postgres database password for the silo user"
}

# no special characters, it's interpolated into silo's REDIS_URL
resource "random_password" "silo_redis_password" {
  length  = 64
  special = false
}

resource "bitwarden-secrets_secret" "silo_redis_password" {
  key        = "SILO_REDIS_PASSWORD"
  value      = random_password.silo_redis_password.result
  project_id = bitwarden_project.this.id
  note       = "Dragonfly password for silo's event bus"
}

# silo-transcode StatefulSet ordinal => silo node id (34 is arbitrary, however required)
locals {
  silo_transcode_node_ids = {
    "0" = 34
    "1" = 35
  }
}

# key format is snk1_<node id>_<32 random bytes as unpadded base64url>
resource "random_bytes" "silo_transcode_node_key" {
  for_each = local.silo_transcode_node_ids
  length   = 32
}

resource "bitwarden-secrets_secret" "silo_transcode_node_key" {
  for_each   = local.silo_transcode_node_ids
  key        = "SILO_TRANSCODE_${each.key}_NODE_KEY"
  value      = "snk1_${each.value}_${replace(replace(trimsuffix(random_bytes.silo_transcode_node_key[each.key].base64, "="), "+", "-"), "/", "_")}"
  project_id = bitwarden_project.this.id
  note       = "node key for silo-transcode-${each.key} (node id ${each.value})"
}

# encrypts plugin configs (OIDC client secret) and other secrets at rest.
resource "random_password" "silo_secret_key" {
  length  = 64
  special = false
}

resource "bitwarden-secrets_secret" "silo_secret_key" {
  key        = "SILO_SECRET_KEY"
  value      = random_password.silo_secret_key.result
  project_id = bitwarden_project.this.id
  note       = "silo SECRET_KEY, master key for at-rest credential encryption"
}

resource "random_password" "silo_oidc_password" {
  length           = 30
  special          = true
  override_special = "!@#%&*()-_=+[]{}<>:"
}

resource "random_password" "silo_oidc_salt" {
  length  = 8
  special = false
}

resource "htpasswd_password" "silo_oidc_hash" {
  password = random_password.silo_oidc_password.result
  salt     = random_password.silo_oidc_salt.result
}

resource "bitwarden-secrets_secret" "silo_oidc_password" {
  key        = "SILO_OIDC_PASSWORD"
  value      = random_password.silo_oidc_password.result
  project_id = bitwarden_project.this.id
  note       = "silo OIDC client secret, mounted as a file for silo's plugins.yaml"
}

resource "bitwarden-secrets_secret" "silo_oidc_hash" {
  key        = "SILO_OIDC_HASH"
  value      = htpasswd_password.silo_oidc_hash.sha512
  project_id = bitwarden_project.this.id
  note       = "silo OIDC SHA512 password hash"
}

# silo search provider
resource "random_password" "silo_meilisearch_master_key" {
  length  = 64
  special = false
}

resource "bitwarden-secrets_secret" "silo_meilisearch_master_key" {
  key        = "SILO_MEILISEARCH_MASTER_KEY"
  value      = random_password.silo_meilisearch_master_key.result
  project_id = bitwarden_project.this.id
  note       = "silo's Meilisearch master key, also silo's Meilisearch API key"
}

resource "bitwarden-secrets_secret" "silo_theintrodb_api_key" {
  key        = "SILO_THEINTRODB_API_KEY"
  value      = var.theintrodb_api_key
  project_id = bitwarden_project.this.id
  note       = "TheIntroDB API key, mounted as a file for silo's config.yaml"
}

resource "bitwarden-secrets_secret" "silo_openrouter_api_key" {
  key        = "SILO_OPENROUTER_API_KEY"
  value      = var.openrouter_api_key
  project_id = bitwarden_project.this.id
  note       = "OpenRouter API key, mounted as a file for silo's config.yaml ai_providers"
}
