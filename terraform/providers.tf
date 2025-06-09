terraform {
  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "~> 2.50.0"
    }

    bitwarden = {
      source  = "maxlaverse/bitwarden"
      version = ">= 0.13.6"
    }

    random = {
      source  = "hashicorp/random"
      version = "3.7.2"
    }

    htpasswd = {
      source  = "loafoe/htpasswd"
      version = "1.2.1"
    }
  }
}

provider "digitalocean" {
  token             = var.digitalocean_token
  spaces_access_id  = var.digitalocean_spaces_access_id
  spaces_secret_key = var.digitalocean_spaces_secret_key
}

provider "bitwarden" {
  access_token = var.bitwarden_access_token

  experimental {
    embedded_client = true
  }
}

provider "random" {}

provider "htpasswd" {}
