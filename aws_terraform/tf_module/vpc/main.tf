module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name             = "vpc-using-tf-registry"
  cidr             = "192.168.0.0/16"
  instance_tenancy = "default"
  azs              = [var.az1, var.az2]
  private_subnets  = ["192.168.1.0/24", "192.168.2.0/24"]
  public_subnets   = ["192.168.3.0/24", "192.168.4.0/24"]
  # enable_nat_gateway = true
  tags = {
    vpc_module_source = "tf-registry"
    creationdate      = "23/08/2023"
    environment       = "development"
    owner             = "thangadurai.murugan@grabtech.com"
  }
}
