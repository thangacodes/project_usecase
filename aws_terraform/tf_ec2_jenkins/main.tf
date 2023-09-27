terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

### Provisioning VPC with one private/public subnet and IGW and NAT Gateway

resource "aws_vpc" "lab" {
  cidr_block = var.vpc_cidr
  tags       = merge(var.identity, { Name = "LAB_VPC" }, { cidr_block = var.vpc_cidr })
}
## Public Subnet Creation
resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.lab.id
  cidr_block              = var.public_subnet1
  availability_zone       = "ap-south-1a"
  map_public_ip_on_launch = true
  tags                    = merge(var.identity, { Name = "Private-Subnet1" }, { cidr_block = var.private_subnet1 })
}
## Private Subnet Creation
resource "aws_subnet" "private" {
  vpc_id            = aws_vpc.lab.id
  cidr_block        = var.private_subnet1
  availability_zone = "ap-south-1a"
  tags              = merge(var.identity, { Name = "Private_subnet1" }, { cidr_block = var.private_subnet1 })
}
## Internet Gateway creation
resource "aws_internet_gateway" "labigw" {
  vpc_id = aws_vpc.lab.id
  tags   = merge(var.identity, { Name = "LAB-IGW" })
}
## Elastic IP creation
resource "aws_eip" "eip" {
  vpc  = true
  tags = merge(var.identity, { Name = "Reserve Public Ip" })
}
## NAT gateway creation
resource "aws_nat_gateway" "labnat" {
  allocation_id = aws_eip.eip.id
  subnet_id     = aws_subnet.public.id
  tags          = merge(var.identity, { Name = "LABNAT Gateway" })
  depends_on    = [aws_eip.eip]
}
## Route Table Creation for private
resource "aws_route_table" "privateRT" {
  vpc_id = aws_vpc.lab.id
  tags   = merge(var.identity, { Name = "PrivateRT" })
}
##Route Table Creation for public
resource "aws_route_table" "publicRT" {
  vpc_id = aws_vpc.lab.id
  tags   = merge(var.identity, { Name = "PublicRT" })
}
## Public Route Creation
resource "aws_route" "public-route" {
  route_table_id         = aws_route_table.publicRT.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.labigw.id
}
## Private Route Creation
resource "aws_route" "private-route" {
  route_table_id         = aws_route_table.privateRT.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_nat_gateway.labnat.id
}
## Public subnet association
resource "aws_route_table_association" "pubsubnet1" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.publicRT.id
}
## Private subnet association
resource "aws_route_table_association" "pvtsubnet2" {
  subnet_id      = aws_subnet.private.id
  route_table_id = aws_route_table.privateRT.id
}
