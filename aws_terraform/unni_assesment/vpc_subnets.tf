resource "aws_vpc" "lab" {
  cidr_block = var.vpc_network
  tags = {
    Name = "Lab-VPC"
  }
}

data "aws_availability_zones" "available" {}
resource "aws_subnet" "private" {
  count             = 2
  vpc_id            = aws_vpc.lab.id
  cidr_block        = cidrsubnet(element(var.pvt_subnets, count.index), 8, 0)
  availability_zone = element(data.aws_availability_zones.available.names, count.index)
  tags = {
    Name = "Lab-private-subnet-${count.index + 1}"
  }
}

resource "aws_subnet" "public" {
  count             = 2
  vpc_id            = aws_vpc.lab.id
  cidr_block        = cidrsubnet(element(var.pub_subnets, count.index), 8, 0)
  availability_zone = element(data.aws_availability_zones.available.names, count.index)
  tags = {
    Name = "Lab-public-subnet-${count.index + 1}"
  }
}
resource "aws_internet_gateway" "public" {
  vpc_id = aws_vpc.lab.id
  tags = {
    Name = "Lab-pub-internet-gateway"
  }
}