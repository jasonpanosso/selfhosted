terraform {
  required_providers {
    bitwarden = {
      source  = "maxlaverse/bitwarden"
      version = "0.17.6"
    }

    bitwarden-secrets = {
      source  = "bitwarden/bitwarden-secrets"
      version = "1.0.0"
    }

  }

  required_version = "~> 1.13.0"
}
