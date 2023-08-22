locals {
  cluster_names = [
    "demo-cluster-4",
    "demo-cluster-2",
    "demo-cluster-3",
    "demo-cluster-1",
  ]
}

locals {
  env     = "Development"
  date    = "21/08/2023"
  owner   = "Thangadurai.murugan@grabtech.com"
  cost    = "10034567"
  ami_id  = "ami-012b9156f755804f5"
  key     = "admin.pem"
  vm_type = "t2.micro"
  sgp     = "sg-0fb1052b659369aa8"
}

locals {
  vm_names = [
    "ap-south-web1",
    "ap-south-web2",
    "ap-south-web3",
    "ap-south-web4",
  ]
}
