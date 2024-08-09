terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.46.0"
    }
  }
  backend "s3" {
    bucket  = "gitops-demo-bucket-tf"
    key     = "eks/terraform.tfstate"
    region  = "ap-south-1"
    encrypt = true
  }
}
