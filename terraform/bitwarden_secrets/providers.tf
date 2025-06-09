terraform {
  required_version = "1.12.0"

  required_providers {
    bitwarden = {
      source  = "maxlaverse/bitwarden"
      version = ">= 0.13.6"
    }

    htpasswd = {
      source  = "loafoe/htpasswd"
      version = "1.2.1"
    }
  }
}
