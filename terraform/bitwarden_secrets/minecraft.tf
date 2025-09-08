resource "random_password" "minecraft_cobblemon_rcon_password" {
  length  = 64
  special = false
}

resource "bitwarden_secret" "minecraft_cobblemon_rcon_password" {
  key        = "MINECRAFT_COBBLEMON_RCON_PASSWORD"
  value      = random_password.minecraft_cobblemon_rcon_password.result
  project_id = bitwarden_project.this.id
  note       = "Minecraft Cobblemon server RCON password"
}

resource "bitwarden_secret" "curseforge_api_key" {
  key        = "CURSEFORGE_API_KEY"
  value      = var.curseforge_api_key
  project_id = bitwarden_project.this.id
  note       = "Curseforge developer API key"
}
