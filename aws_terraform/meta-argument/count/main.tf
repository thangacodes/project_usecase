locals {
  availability_zones   = ["ap-south-1a", "ap-south-1b", "ap-south-1c"]
  vpc_cidr             = "200.0.0.0/16"
  private_subnets_cidr = ["200.0.0.0/24", "200.0.1.0/24", "200.0.2.0/24"]
  public_subnets_cidr  = ["200.0.3.0/24", "200.0.4.0/24", "200.0.5.0/24"]
  tagging = {
    Environment  = "Staging"
    Public_Cloud = "AWS"
    Project      = "Cloudbird.fun"
    Owner        = "thangadurai.murugan@example.com"
  }
}

resource "aws_vpc" "myvpc" {
  cidr_block = local.vpc_cidr
  tags       = merge(local.tagging, { Name = "MY-VPC" })
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.myvpc.id

  tags = merge(local.tagging, { Name = "MY-VPC-IGW" })
}

resource "aws_subnet" "private" {
  vpc_id            = aws_vpc.myvpc.id
  count             = 3
  cidr_block        = local.private_subnets_cidr[count.index]
  availability_zone = local.availability_zones[count.index]
  tags              = merge(local.tagging, { Name = "Private-Subnet-${count.index + 1}" })
}

resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.myvpc.id
  count                   = 3
  cidr_block              = local.public_subnets_cidr[count.index]
  availability_zone       = local.availability_zones[count.index]
  map_public_ip_on_launch = true
  tags                    = merge(local.tagging, { Name = "Public-Subnet-${count.index + 1}" })
}

resource "aws_route_table" "publicrt" {
  vpc_id = aws_vpc.myvpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = merge(local.tagging, { Name = "Public-RT" })
}

resource "aws_route_table_association" "publicsubnetassoc" {
  count          = 3
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.publicrt.id
}

resource "aws_route_table" "privatert" {
  vpc_id = aws_vpc.myvpc.id
  tags   = merge(local.tagging, { Name = "Private-RT" })
}

resource "aws_route_table_association" "privatesubnetassoc" {
  count          = 3
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.privatert.id
}
