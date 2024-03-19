## Configuring provider
terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}
provider "aws" {
  region = "ap-south-1"
}

## Data Source: aws_availability_zones

data "aws_availability_zones" "available" {}

