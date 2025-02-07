region      = "ap-south-1"
profile     = "vault_admin"
vpc_network = "192.168.0.0/16"
pvt_subnets = ["192.168.151.0/24", "192.168.152.0/24"]
pub_subnets = ["192.168.153.0/24", "192.168.154.0/24"]
vmspec      = "t2.micro"
sshkey      = "mac"
ec2_sgp     = "sg-0fb1052b659369aa8"