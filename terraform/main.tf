module "spaces" {
  source  = "terraform-do-modules/spaces/digitalocean"
  version = "1.0.0"

  name       = var.spaces_name
  region     = var.spaces_region
  acl        = "private"
  versioning = true
}

resource "digitalocean_spaces_key" "this" {
  name = "${module.spaces.name}-key"

  grant {
    bucket     = module.spaces.name
    permission = "readwrite"
  }
}
