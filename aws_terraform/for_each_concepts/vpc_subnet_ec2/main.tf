resource "aws_vpc" "multi_vpc_creation" {
  for_each   = var.vpc_cidrip
  cidr_block = each.value
  tags = {
    "Name" = each.key
  }
}

resource "aws_internet_gateway" "multi_igw" {
  for_each = aws_vpc.multi_vpc_creation
  vpc_id   = each.value.id
  tags = {
    "Name" = "${each.key}-IGW"
  }
}

resource "aws_subnet" "dev_private_subnets" {
  vpc_id            = aws_vpc.multi_vpc_creation["dev"].id
  for_each          = var.dev_subnet_ipranges
  cidr_block        = each.value
  availability_zone = "ap-south-1a"
}

resource "aws_subnet" "stage_private_subnets" {
  vpc_id            = aws_vpc.multi_vpc_creation["staging"].id
  for_each          = var.stage_subnet_ipranges
  cidr_block        = each.value
  availability_zone = "ap-south-1a"
}

resource "aws_subnet" "prod_private_subnets" {
  vpc_id            = aws_vpc.multi_vpc_creation["prod"].id
  for_each          = var.prod_subnet_ipranges
  cidr_block        = each.value
  availability_zone = "ap-south-1a"
}

resource "aws_instance" "multi_ec2" {
  for_each      = aws_vpc.multi_vpc_creation
  ami           = var.ami_id
  instance_type = var.vmspec
  key_name      = var.sshkey
  associate_public_ip_address = true
  subnet_id = lookup(
    {
      "dev"     = aws_subnet.dev_private_subnets["private_subnet_1"].id,
      "staging" = aws_subnet.stage_private_subnets["private_subnet_1"].id, 
      "prod"    = aws_subnet.prod_private_subnets["private_subnet_1"].id   
    },
    each.key
  )
  tags = {
    "Name" = "${each.key}-ec2-instance"
  }
}
