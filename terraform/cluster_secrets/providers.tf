terraform {
  required_providers {
    bitwarden = {
      source  = "maxlaverse/bitwarden"
      version = ">= 0.16.0"
    }

    bitwarden-secrets = {
      source = "bitwarden/bitwarden-secrets"
      version = ">= 1.0.0"
    }
  }
}
