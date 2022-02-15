terraform {
  cloud {
  organization = "navinku-org"
  workspaces {
    name = "API-workspace"
  }
}
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.27"
    }
  }

  required_version = ">= 0.14.9"
}

provider "aws" {
  profile = "deep-dive"
  region  = "us-east-1"
}