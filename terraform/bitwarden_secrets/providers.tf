terraform {
  required_providers {
    b2 = {
      source  = "Backblaze/b2"
      version = "0.14.1"
    }

    bitwarden = {
      source  = "maxlaverse/bitwarden"
      version = "0.17.6"
    }

    bitwarden-secrets = {
      source  = "bitwarden/bitwarden-secrets"
      version = "1.0.0"
    }

    htpasswd = {
      source  = "loafoe/htpasswd"
      version = "2.3.0"
    }

    random = {
      source  = "hashicorp/random"
      version = "3.7.2"
    }
  }

  required_version = "~> 1.13.0"
}
