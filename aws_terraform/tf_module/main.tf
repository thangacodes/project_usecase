# Terraform config
terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}

# Cloud provider details
provider "aws" {
  region = var.region
}

# Data source for availability zones
data "aws_availability_zones" "region_wise_avail_zone" {
  state = "available"
}

# load child vpc-module
module "vpc_with_tf_registry" {
  source = "./vpc/"

  az1 = data.aws_availability_zones.region_wise_avail_zone.names[0]
  az2 = data.aws_availability_zones.region_wise_avail_zone.names[1]
}

# load child static-web-host module
module "prod_website" {
  source        = "./static_web/"
  bucket_prefix = "my-demo-tf-s3-website-host-bucket"
}
