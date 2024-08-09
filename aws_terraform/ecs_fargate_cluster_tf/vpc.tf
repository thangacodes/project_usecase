resource "aws_vpc" "vpc" {
  cidr_block = "192.168.0.0/16"
  tags       = merge(var.tagging, { Name = "Lab-VPC" })
}

resource "aws_subnet" "pubsub1" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = "192.168.1.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "ap-south-1a"
  tags                    = merge(var.tagging, { Name = "public-sub1" })
}


resource "aws_subnet" "pubsub2" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = "192.168.2.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "ap-south-1b"
  tags                    = merge(var.tagging, { Name = "public-sub2" })
}

resource "aws_internet_gateway" "IG" {
  vpc_id = aws_vpc.vpc.id
  tags   = merge(var.tagging, { Name = "Internet-Gateway" })
}

resource "aws_route_table" "RT" {
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.IG.id
  }
}

resource "aws_route_table_association" "RTA1" {
  subnet_id      = aws_subnet.pubsub1.id
  route_table_id = aws_route_table.RT.id
}


resource "aws_route_table_association" "RTA2" {
  subnet_id      = aws_subnet.pubsub2.id
  route_table_id = aws_route_table.RT.id
}
