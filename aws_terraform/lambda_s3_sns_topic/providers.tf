terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.84.0"
    }
  }
}
provider "aws" {
  region  = var.region
  profile = var.aws_profile_name
}
