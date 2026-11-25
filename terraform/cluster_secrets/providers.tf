terraform {
  required_providers {
    bitwarden = {
      source  = "maxlaverse/bitwarden"
      version = "0.24.0"
    }

    bitwarden-secrets = {
      source  = "bitwarden/bitwarden-secrets"
      version = "1.0.1"
    }

  }

  required_version = "~> 1.13.0"
}
