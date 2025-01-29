region  = "ap-south-1"
profile = "vault_admin"
vpc_cidrip  = {
  "dev"     = "192.168.0.0/16",
  "staging" = "192.168.0.0/17",
  "prod"    = "192.168.0.0/24"
}
dev_subnet_ipranges  = {
  "private_subnet_1" = "192.168.0.0/24",
  "private_subnet_2" = "192.168.1.0/24",
  "private_subnet_3" = "192.168.2.0/24"
}

stage_subnet_ipranges = {
  "private_subnet_1"  = "192.168.0.0/19",
  "private_subnet_2"  = "192.168.32.0/19",
  "private_subnet_3"  = "192.168.64.0/19"
}

prod_subnet_ipranges = {
  "private_subnet_1" = "192.168.0.0/26",
  "private_subnet_2" = "192.168.0.64/26",
  "private_subnet_3" = "192.168.0.128/26"
}

ami_id = "ami-05fa46471b02db0ce"
vmspec = "t2.micro"
sshkey = "mac"
