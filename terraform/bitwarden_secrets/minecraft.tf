resource "random_password" "minecraft_create_rcon_password" {
  length  = 64
  special = false
}

resource "bitwarden_secret" "minecraft_create_rcon_password" {
  key        = "MINECRAFT_CREATE_RCON_PASSWORD"
  value      = random_password.minecraft_create_rcon_password.result
  project_id = bitwarden_project.this.id
  note       = "Minecraft Create server RCON password"
}
