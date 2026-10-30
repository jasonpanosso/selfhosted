terraform {
  required_providers {
    b2 = {
      source  = "Backblaze/b2"
      version = ">= 0.14.1"
    }

    bitwarden = {
      source  = "maxlaverse/bitwarden"
      version = ">= 0.16.0"
    }

    bitwarden-secrets = {
      source  = "bitwarden/bitwarden-secrets"
      version = ">= 1.0.0"
    }

    htpasswd = {
      source  = "loafoe/htpasswd"
      version = ">= 1.2.1"
    }
  }
}
