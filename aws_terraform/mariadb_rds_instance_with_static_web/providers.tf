terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.9.0"
    }
  }
  backend "s3" {
    bucket = "gitops-demo-bucket-tf"
    key    = "rds_tf_state/terraform.tfstate"
    region = "ap-south-1"
  }
}

provider "aws" {
  region                   = var.region
  shared_config_files      = ["~/.aws/config"]
  shared_credentials_files = ["~/.aws/credentials"]
}
