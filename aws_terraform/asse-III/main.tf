module "vpc" {
  source = "./vpc"
}

module "ec2" {
  source      = "./ec2"
  publicsubid = module.vpc.pubsubid
  sgpid       = module.vpc.sgpid
}