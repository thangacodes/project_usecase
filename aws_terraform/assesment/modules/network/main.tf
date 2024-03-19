/* Provider block */
terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}
provider "aws" {
  region = var.region
}

/* Data Source filtering for availability_zones */
data "aws_availability_zones" "available" {}

/* VPC && Internet Gateway creation*/
resource "aws_vpc" "tfvpc" {
  cidr_block = var.vpc_cidr
  tags       = merge(var.tagging, { Name = "TFVPC" })
}
resource "aws_internet_gateway" "tfvpc-igw" {
  vpc_id = aws_vpc.tfvpc.id
  tags   = merge(var.tagging, { Name = "TFVPC-IGW" })
}

/* Private/Public Subnets creation*/
resource "aws_subnet" "private" {
  count                   = length(var.private_subnetcidrs)
  vpc_id                  = aws_vpc.tfvpc.id
  cidr_block              = var.private_subnetcidrs[count.index]
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = false
  depends_on              = [aws_vpc.tfvpc]
  tags                    = merge(var.tagging, { Name = "Private-Subnet-${count.index + 1}" })
}
resource "aws_subnet" "public" {
  count                   = length(var.public_subnetcidrs)
  vpc_id                  = aws_vpc.tfvpc.id
  cidr_block              = var.public_subnetcidrs[count.index]
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = true
  depends_on              = [aws_vpc.tfvpc]
  tags                    = merge(var.tagging, { Name = "Public-Subnet-${count.index + 1}" })
}
/* Reserving an Elastic IP and NAT Gateway creation*/
resource "aws_eip" "nat_eip" {
  domain = "vpc"
}
resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = element(aws_subnet.public.*.id, 4)
  depends_on    = [aws_internet_gateway.tfvpc-igw]
  tags          = merge(var.tagging, { Name = "TFC_NATGW" })
}
/* RouteTable and route creation for public subnets*/
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.tfvpc.id
  tags   = merge(var.tagging, { Name = "Public-RT" })
}
resource "aws_route" "public" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.tfvpc-igw.id
}
/* RouteTable and route creation for private subnets*/
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.tfvpc.id
  tags   = merge(var.tagging, { Name = "Private-RT" })
}
resource "aws_route" "private" {
  route_table_id         = aws_route_table.private.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat.id
}

/* Route table associations */
resource "aws_route_table_association" "public" {
  count          = length(var.public_subnetcidrs)
  subnet_id      = element(aws_subnet.public.*.id, count.index)
  route_table_id = aws_route_table.public.id
}

/* Route table associations */
resource "aws_route_table_association" "private" {
  count          = length(var.private_subnetcidrs)
  subnet_id      = element(aws_subnet.private.*.id, count.index)
  route_table_id = aws_route_table.private.id
}
