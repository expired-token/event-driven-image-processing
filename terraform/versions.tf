terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }

  backend "s3" {
    bucket       = "remote-state-management-oaws-867637277826"
    key          = "state/terraform.tfstate"
    encrypt      = true
    use_lockfile = true
  }
}