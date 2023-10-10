# Creating VPC with Public Subnets
resource "aws_vpc" "cloudbird" {
  cidr_block = local.vpc_cidr
  tags       = merge(var.identify, { Name = "Cloudbird-VPC" })
}

# Public Subnets Creation
resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.cloudbird.id
  for_each                = var.public_subnet_range
  cidr_block              = each.value
  availability_zone       = local.avail_zone
  map_public_ip_on_launch = true
  tags                    = merge(var.identify, { Name = each.key })
}

# Private Subnets Creation
resource "aws_subnet" "private" {
  vpc_id            = aws_vpc.cloudbird.id
  for_each          = var.private_subnet_range
  cidr_block        = each.value
  availability_zone = local.avail_zone
  tags              = merge(var.identify, { Name = each.key })
}

# Internet Gateway Creation
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.cloudbird.id
  tags   = merge(var.identify, { Name = "Cloudbird-Internet-Gateway" })
}

# Public Route Table Creation and association to the VPC
resource "aws_route_table" "pubRT" {
  vpc_id = aws_vpc.cloudbird.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = merge(var.identify, { Name = "Public-RouteTable" })
}

# Associate public subnets to the PublicRT
resource "aws_route_table_association" "public_subnet_association" {
  for_each       = var.public_subnet_range
  subnet_id      = each.value
  route_table_id = aws_route_table.pubRT.id
}

# Reserving a Public IP
resource "aws_eip" "natip" {
  vpc = true
}

# NAT gateway creation
resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.natip.id
  #subnet_id     = aws_subnet.private[*].id
  for_each = aws_subnet.private[each.key.id]
  tags     = merge(var.identify, { Name = "Private-NAT-Gateway" })
}

# Private Route Table Creation and association to the VPC
resource "aws_route_table" "privRT" {
  vpc_id = aws_vpc.cloudbird.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.nat.id
  }
  tags = merge(var.identify, { Name = "Private-RouteTable" })
}

# Associate private subnets to the PrivateRT
resource "aws_route_table_association" "private_subnet_association" {
  for_each       = var.private_subnet_range
  subnet_id      = each.value
  route_table_id = aws_route_table.privRT.id
}

# ## IP Target Group
# resource "aws_lb_target_group" "iptgp" {
#   name        = local.lb_target_name
#   port        = local.port
#   protocol    = local.protocol
#   target_type = "ip"
#   vpc_id      = aws_vpc.cloudbird.id
#   depends_on  = [aws_lb.cloudbird]
# }

# # Provision Network Load Balancer
# resource "aws_lb" "cloudbird" {
#   name                       = local.lb_name
#   internal                   = false
#   load_balancer_type         = local.lb_type
#   subnets                    = aws_subnet.public[*].id
#   enable_deletion_protection = true
#   tags                       = merge(var.identify, { Name = local.lb_name })
# }

# # Target_group_attachment 
# resource "aws_lb_target_group_attachment" "cloudbird" {
#   target_group_arn  = aws_lb_target_group.iptgp.arn
#   target_id         = aws_lb_target_group.iptgp.id
#   availability_zone = "ap-south-1a"
#   port              = local.port
# }
