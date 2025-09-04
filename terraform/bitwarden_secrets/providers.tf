terraform {
  required_providers {
    bitwarden = {
      source  = "maxlaverse/bitwarden"
      version = ">= 0.16.0"
    }

    htpasswd = {
      source  = "loafoe/htpasswd"
      version = ">= 1.2.1"
    }
  }
}
