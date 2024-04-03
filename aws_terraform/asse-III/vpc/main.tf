locals {
  zone = "ap-south-1a"
}

resource "aws_vpc" "corp" {
  cidr_block = var.vpc_cidr
  tags       = merge(var.tagging, { Name = "CORPVPC" })
}

resource "aws_internet_gateway" "corpigw" {
  vpc_id = aws_vpc.corp.id
  tags   = merge(var.tagging, { Name = "corpigw" })
}

resource "aws_subnet" "private" {
  vpc_id            = aws_vpc.corp.id
  count             = 2
  cidr_block        = var.privatesub[count.index]
  availability_zone = local.zone
  tags              = merge(var.tagging, { Name = "Privatesubnet-${count.index + 1}" })
}

resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.corp.id
  count                   = 2
  cidr_block              = var.publicsub[count.index]
  map_public_ip_on_launch = true
  availability_zone       = local.zone
  tags                    = merge(var.tagging, { Name = "Publicsubnet-${count.index + 1}" })
}

resource "aws_security_group" "jenkinssg" {
  vpc_id = aws_vpc.corp.id
  name   = "jenkins-sgp"
  ingress {
    from_port   = "22"
    to_port     = "22"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "jenkins-sgp"
  }
}

resource "aws_route_table" "pubrt" {
  vpc_id = aws_vpc.corp.id
  tags   = merge(var.tagging, { Name = "Public-RT" })
}

resource "aws_route_table" "pvtrt" {
  vpc_id = aws_vpc.corp.id
  tags   = merge(var.tagging, { Name = "Private-RT" })
}

resource "aws_route" "public" {
  route_table_id         = aws_route_table.pubrt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.corpigw.id
}

resource "aws_route_table_association" "public" {
  count          = 2
  subnet_id      = element(aws_subnet.public.*.id, count.index)
  route_table_id = aws_route_table.pubrt.id
}