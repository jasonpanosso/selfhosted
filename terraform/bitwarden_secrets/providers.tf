terraform {
  required_providers {
    b2 = {
      source  = "Backblaze/b2"
      version = "0.14.1"
    }

    bitwarden = {
      source  = "maxlaverse/bitwarden"
      version = "0.24.0"
    }

    bitwarden-secrets = {
      source  = "bitwarden/bitwarden-secrets"
      version = "1.0.1"
    }

    htpasswd = {
      source  = "loafoe/htpasswd"
      version = "2.3.0"
    }

    random = {
      source  = "hashicorp/random"
      version = "3.9.1"
    }

    tls = {
      source  = "hashicorp/tls"
      version = "4.4.2"
    }
  }

  required_version = "~> 1.13.0"
}
