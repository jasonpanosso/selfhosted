terraform {
  backend "s3" {
    bucket = "jasonpanosso-terraform-state"
    key    = "selfhosted/terraform.tfstate"
    region = "us-east-1"

    use_lockfile = true
    encrypt      = true
  }

  required_version = "~> 1.11.3"
}
