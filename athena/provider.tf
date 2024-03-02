terraform {
  required_version = "~> 1.7.0"
  backend "s3" {}
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.39.0"
    }
  }
}

provider "aws" {
  profile = "default"
}