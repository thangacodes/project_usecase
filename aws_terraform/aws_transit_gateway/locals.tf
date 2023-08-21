locals {
  vpc1         = "vpc1"
  vpc2         = "vpc2"
  CreationDate = "18/08/2023"

  vpc1_public_subnet  = "pubsub_vpc1"
  vpc1_private_subnet = "pvtsub_vpc1"
  vpc2_public_subnet  = "pubsub_vpc2"
  vpc2_private_subnet = "pvtsub_vpc2"

  vpc1_igw     = "public_igw_vpc1"
  vpc2_igw     = "pvt_igw_vpc2"
  ami_id       = "ami-012b9156f755804f5"
  keyname      = "admin"
  transit_name = "connection_bw_vpc12"
  environment  = "Development"
}
