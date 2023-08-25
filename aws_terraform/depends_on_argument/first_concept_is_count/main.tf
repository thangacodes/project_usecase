## provisioning set of vm's in aws cloud
resource "aws_instance" "web" {
  ami                    = local.ami_id
  instance_type          = local.vm_type
  vpc_security_group_ids = ["local.sgp_id"]
  key_name               = local.keypair
  count                  = 5
  tags                   = merge(var.tagging, { Name = "WebServer-${count.index}" })
}

## provisioning a VPC with multi subnets like private/public ones
resource "aws_vpc" "lab" {
  cidr_block = local.vpccidr
  tags       = merge(var.tagging, { Name = "LAB-VPC" })
}

## Create three private subnets using count meta-argument concept
resource "aws_subnet" "private" {
  vpc_id     = aws_vpc.lab.id
  count      = 5
  cidr_block = "192.168.${count.index}.0/24"
  tags       = merge(var.tagging, { Name = "PrivateSubnet-${count.index}" })
}

## Create three public subnets using count meta-argument concept
resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.lab.id
  count                   = 5
  cidr_block              = "192.168.${10 + count.index}.0/24"
  map_public_ip_on_launch = true
  tags                    = merge(var.tagging, { Name = "PublicSubnet-${count.index}" })
}
