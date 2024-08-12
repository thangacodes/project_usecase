resource "aws_vpc" "labvpc" {
  cidr_block = var.vpccidr
  tags       = merge(var.tagging, { Name = "SANDBOX-VPC" })
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.labvpc.id
  tags   = merge(var.tagging, { Name = "SANDBOX-IGW" })
}

resource "aws_subnet" "pubsubnet" {
  for_each                = { for pubip, subnet in var.pubsub : pubip => subnet }
  vpc_id                  = aws_vpc.labvpc.id
  cidr_block              = each.value.cidr
  map_public_ip_on_launch = true
  tags = {
    Name        = each.value.name
    Environment = "Sandbox"
  }
}

resource "aws_subnet" "pvtsubnet" {
  for_each   = { for pvtip, subnet in var.pvtsub : pvtip => subnet }
  vpc_id     = aws_vpc.labvpc.id
  cidr_block = each.value.cidr
  tags = {
    Name        = each.value.name
    Environment = "Sandbox"
  }
}

resource "aws_route_table" "pubrt" {
  vpc_id = aws_vpc.labvpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }
  tags = merge(var.tagging, { Name = "Public-RT" })
}

resource "aws_route_table_association" "pusubnetassoc" {
  for_each       = aws_subnet.pubsubnet
  subnet_id      = each.value.id
  route_table_id = aws_route_table.pubrt.id
}

resource "aws_route_table" "pvtrt" {
  vpc_id = aws_vpc.labvpc.id
  tags   = merge(var.tagging, { Name = "Private-RT" })
}

resource "aws_route_table_association" "pvtsubnetassoc" {
  for_each       = aws_subnet.pvtsubnet
  subnet_id      = each.value.id
  route_table_id = aws_route_table.pvtrt.id
}
