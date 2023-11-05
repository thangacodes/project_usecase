resource "aws_vpc" "vpc-test-1" {
  cidr_block = var.vpc_cidr_test1
  tags = {
    Name        = "vpc_demo_test_1"
    Environment = "Development"
    cidr_block  = var.vpc_cidr_test1
    Owner       = "tm@example.com"
  }
}
resource "aws_vpc" "vpc-test-2" {
  cidr_block = var.vpc_cidr_test2
  tags = {
    Name        = "vpc_demo_test_2"
    Environment = "Development"
    cidr_block  = var.vpc_cidr_test2
    Owner       = "tm@example.com"
  }
}

## Creating two Internet gateways
resource "aws_internet_gateway" "vpc-test-igw1" {
  vpc_id = aws_vpc.vpc-test-1.id
}
resource "aws_internet_gateway" "vpc-test-igw2" {
  vpc_id = aws_vpc.vpc-test-2.id
}

### Creating two public subnets and two route tables for it

resource "aws_subnet" "vpc-public-subnet1" {
  cidr_block        = var.vpc_pub_sub1_range
  vpc_id            = aws_vpc.vpc-test-1.id
  availability_zone = var.avail_zone
  tags = {
    Name        = "VPC-1-PUB-SUBNET-1"
    cidr_block  = var.vpc_pub_sub1_range
    Owner       = "tm@example.com"
    Environment = "Development"
  }
}
resource "aws_subnet" "vpc-public-subnet2" {
  cidr_block        = var.vpc_pub_sub2_range
  vpc_id            = aws_vpc.vpc-test-2.id
  availability_zone = var.avail_zone
  tags = {
    Name        = "VPC-1-PUB-SUBNET-2"
    cidr_block  = var.vpc_pub_sub2_range
    Owner       = "tm@example.com"
    Environment = "Development"
  }
}

#### Two route table creation
resource "aws_route_table" "vpc-test-rt1" {
  vpc_id = aws_vpc.vpc-test-1.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.vpc-test-igw1.id
  }
  tags = {
    Name        = "VPC-TEST-1-RT1"
    Owner       = "tm@example.com"
    Environment = "Development"
  }
}
resource "aws_route_table" "vpc-test-rt2" {
  vpc_id = aws_vpc.vpc-test-2.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.vpc-test-igw2.id
  }
  tags = {
    Name        = "VPC-TEST-2-RT2"
    Owner       = "tm@example.com"
    Environment = "Development"
  }
}

### Public subnet association
resource "aws_route_table_association" "pub-1-sub" {
  subnet_id      = aws_subnet.vpc-public-subnet1.id
  route_table_id = aws_route_table.vpc-test-rt1.id
}
resource "aws_route_table_association" "pub-2-sub" {
  subnet_id      = aws_subnet.vpc-public-subnet2.id
  route_table_id = aws_route_table.vpc-test-rt2.id
}

### Creating two Web servers to check curl after adding into the TGW attachment of VPC's
resource "aws_instance" "vpc-1-webvm" {
  ami                         = var.ami
  instance_type               = var.vm_spec
  key_name                    = var.webkey
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.sg1.id]
  availability_zone           = var.avail_zone
  subnet_id                   = aws_subnet.vpc-public-subnet1.id
  user_data                   = file("webserver_conf.sh")
  tags = {
    Name        = "VPC-TEST-1-WEBVM"
    Owner       = "tm@example.com"
    Environment = "Development"
  }
}
resource "aws_instance" "vpc-2-webvm" {
  ami                         = var.ami
  instance_type               = var.vm_spec
  key_name                    = var.webkey
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.sg2.id]
  availability_zone           = var.avail_zone
  subnet_id                   = aws_subnet.vpc-public-subnet2.id
  user_data                   = file("webserver_conf.sh")
  tags = {
    Name        = "VPC-TEST-2-WEBVM"
    Owner       = "tm@example.com"
    Environment = "Development"
  }
}

#### Transit Gateway creation and attachments
resource "aws_ec2_transit_gateway" "demo-tgw" {
  description                     = "Connecting two vpc's using this TGW"
  default_route_table_association = "enable"
  default_route_table_propagation = "enable"
  tags = {
    Name        = "TEST-TGW"
    Environment = "Development"
    Owner       = "tm@example.com"
  }
}

resource "aws_ec2_transit_gateway_vpc_attachment" "test-vpc-1" {
  subnet_ids         = [aws_subnet.vpc-public-subnet1.id]
  transit_gateway_id = aws_ec2_transit_gateway.demo-tgw.id
  vpc_id             = aws_vpc.vpc-test-1.id
  tags = {
    Name        = "TEST-1-VPC-TRANSITGW-ATTACHMENT"
    Environment = "Development"
    Owner       = "tm@example.com"
  }
}
resource "aws_ec2_transit_gateway_vpc_attachment" "test-vpc-2" {
  subnet_ids         = [aws_subnet.vpc-public-subnet2.id]
  transit_gateway_id = aws_ec2_transit_gateway.demo-tgw.id
  vpc_id             = aws_vpc.vpc-test-2.id
  tags = {
    Name        = "TEST-2-VPC-TRANSITGW-ATTACHMENT"
    Environment = "Development"
    Owner       = "tm@example.com"
  }
}
############## CREATE SECURITY GROUP ###################3
resource "aws_security_group" "sg1" {
  name        = "sg1"
  description = "allow ssh from internet and icmp from 10.2.0.0/24"
  vpc_id      = aws_vpc.vpc-test-1.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 80
    to_port     = 80
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
    Name        = "sgp-test-vpc-1"
    Environment = "Development"
    Owner       = "tm@example.com"
  }
}

resource "aws_security_group" "sg2" {
  name        = "sg2"
  description = "allow ssh from internet and icmp from 10.2.0.0/24"
  vpc_id      = aws_vpc.vpc-test-2.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 80
    to_port     = 80
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
    Name        = "sgp-test-vpc-2"
    Environment = "Development"
    Owner       = "tm@example.com"
  }
}
#####################################################################3
# Create route to transist gateway in route table 
resource "aws_route" "tgw-route-1" {
  route_table_id         = aws_route_table.vpc-test-rt1.id
  destination_cidr_block = "16.16.0.0/16"
  transit_gateway_id     = aws_ec2_transit_gateway.demo-tgw.id
  depends_on = [
    aws_ec2_transit_gateway.demo-tgw
  ]
}

# Create route to transist gateway in route table 
resource "aws_route" "tgw-route-2" {
  route_table_id         = aws_route_table.vpc-test-rt2.id
  destination_cidr_block = "15.15.0.0/16"
  transit_gateway_id     = aws_ec2_transit_gateway.demo-tgw.id
  depends_on = [
    aws_ec2_transit_gateway.demo-tgw
  ]
}

