locals {
  common_name = "eks-terraform"
}

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = local.common_name
  cidr = "150.0.0.0/16"

  azs             = ["ap-south-1a", "ap-south-1b", "ap-south-1c"]
  private_subnets = ["150.0.1.0/24", "150.0.2.0/24", "150.0.3.0/24"]
  public_subnets  = ["150.0.6.0/24", "150.0.7.0/24", "150.0.8.0/24"]

  enable_nat_gateway = true

  tags = {
    "kubernetes.io/cluster/${local.common_name}" = "shared"
  }
}
