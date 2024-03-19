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

## The Availability Zones data source allows access to the list of AWS Availability Zones which can be accessed by an AWS account within the region configured in the provider.

data "aws_availability_zones" "available" {}

