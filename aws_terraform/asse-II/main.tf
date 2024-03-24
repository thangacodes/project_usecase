module "vpc" {
  source = "./vpc"
}

module "ec2" {
  source = "./ec2"
  subid  = module.vpc.subid
  sgpid  = module.vpc.sgpid
}