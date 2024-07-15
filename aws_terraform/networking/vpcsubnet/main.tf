## VPC creation
resource "aws_vpc" "demovpc" {
  cidr_block = var.vpccidr
  tags       = merge(var.tagging, { Name = "LAB-VPC" })
}

## Internet Gateway creation
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.demovpc.id
  tags   = merge(var.tagging, { Name = "LAB_IGW" })
}

## Private Subnet
resource "aws_subnet" "private" {
  count             = length(var.private_subnet)
  vpc_id            = aws_vpc.demovpc.id
  cidr_block        = element(var.private_subnet, count.index)
  availability_zone = element(var.ap_availability_zone, count.index)
  tags              = merge(var.tagging, { Name = "Private-Subnet-${count.index + 1}" })
}

## Public Subnet
resource "aws_subnet" "public" {
  count             = length(var.public_subnet)
  vpc_id            = aws_vpc.demovpc.id
  cidr_block        = element(var.public_subnet, count.index)
  availability_zone = element(var.ap_availability_zone, count.index)
  tags              = merge(var.tagging, { Name = "Public-Subnet-${count.index + 1}" })
}

# Public Route Table
resource "aws_route_table" "pubrt" {
  vpc_id = aws_vpc.demovpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = merge(var.tagging, { Name = "Public-RT" })
}

# Private Route Table
resource "aws_route_table" "pvtrt" {
  vpc_id = aws_vpc.demovpc.id
  tags   = merge(var.tagging, { Name = "Private-RT" })
}

## Public Route Table and Public subnet association
resource "aws_route_table_association" "pubasso" {
  count          = length(aws_subnet.public)
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.pubrt.id
}

## Private Route Table and Private subnet association
resource "aws_route_table_association" "pvtasso" {
  count          = length(aws_subnet.private)
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.pvtrt.id
}
