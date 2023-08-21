resource "aws_vpc" "vpc1" {
  cidr_block = "192.168.0.0/16"
  tags = {
    Name = local.vpc1
    Date = local.CreationDate
    env  = local.environment
  }
}
resource "aws_vpc" "vpc2" {
  cidr_block = "10.10.0.0/16"
  tags = {
    Name = local.vpc2
    Date = local.CreationDate
    env  = local.environment
  }
}

resource "aws_subnet" "publicsub" {
  vpc_id            = aws_vpc.vpc1.id
  cidr_block        = "192.168.1.0/24"
  availability_zone = "ap-south-1a"
  tags = {
    Name = local.vpc1_public_subnet
    Date = local.CreationDate
    env  = local.environment
  }
}
resource "aws_subnet" "privatesub" {
  vpc_id            = aws_vpc.vpc1.id
  cidr_block        = "192.168.2.0/24"
  availability_zone = "ap-south-1a"
  tags = {
    Name = local.vpc1_private_subnet
    Date = local.CreationDate
    env  = local.environment
  }
}

resource "aws_subnet" "pubsub" {
  vpc_id            = aws_vpc.vpc2.id
  cidr_block        = "10.10.1.0/24"
  availability_zone = "ap-south-1b"
  tags = {
    Name = local.vpc2_public_subnet
    Date = local.CreationDate
    env  = local.environment
  }
}
resource "aws_subnet" "pvtsub" {
  vpc_id            = aws_vpc.vpc2.id
  cidr_block        = "10.10.2.0/24"
  availability_zone = "ap-south-1b"
  tags = {
    Name = local.vpc2_private_subnet
    Date = local.CreationDate
    env  = local.environment
  }
}

resource "aws_internet_gateway" "vpc1-igw" {
  vpc_id = aws_vpc.vpc1.id

  tags = {
    Name = local.vpc1_igw
    Date = local.CreationDate
    env  = local.environment
  }
}

resource "aws_internet_gateway" "vpc2-igw" {
  vpc_id = aws_vpc.vpc2.id

  tags = {
    Name = local.vpc2_igw
    Date = local.CreationDate
    env  = local.environment
  }
}
#Create route table for public subnets
resource "aws_route_table" "vpc1pubrt" {
  vpc_id = aws_vpc.vpc1.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.vpc1-igw.id
  }

  tags = {
    Name = "vpc1-pubrt"
    Tier = "public"
    Date = local.CreationDate
    env  = local.environment
  }
}

resource "aws_route_table" "vpc2pubrt" {
  vpc_id = aws_vpc.vpc2.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.vpc2-igw.id
  }

  tags = {
    Name = "vpc2-pubrt"
    Tier = "public"
    Date = local.CreationDate
    env  = local.environment
  }
}

### Subnet association on vpc route table
resource "aws_route_table_association" "vpc1pubsub" {
  route_table_id = aws_route_table.vpc1pubrt.id
  subnet_id      = aws_subnet.publicsub.id
}
resource "aws_route_table_association" "vpc2pubsub" {
  route_table_id = aws_route_table.vpc2pubrt.id
  subnet_id      = aws_subnet.pubsub.id
}

# create tgw in AWS Network Account 
resource "aws_ec2_transit_gateway" "mumbai-a" {

  description = "Transit Gateway testing scenario with 2 VPCs, subnets each"
  tags = {
    Name = local.transit_name
    env  = local.environment
    Date = local.CreationDate
  }
}
## Attachement of VPC1 from AWS production Account

resource "aws_ec2_transit_gateway_vpc_attachment" "mumbaia_vpc_attachment" {

  subnet_ids         = [aws_subnet.publicsub.id]
  transit_gateway_id = aws_ec2_transit_gateway.mumbai-a.id
  vpc_id             = aws_vpc.vpc1.id
  tags = {
    Name = "TG-ATTA-1"
    Date = local.CreationDate
    env  = local.environment
  }
}

## Attachement of VPC2 from AWS production Account
resource "aws_ec2_transit_gateway_vpc_attachment" "mumbaib_vpc_attachment" {

  subnet_ids         = [aws_subnet.pubsub.id]
  transit_gateway_id = aws_ec2_transit_gateway.mumbai-a.id
  vpc_id             = aws_vpc.vpc2.id
  tags = {
    Name = "TG-ATTA-2"
    Date = local.CreationDate
    env  = local.environment
  }
}

### AWS Transit Gateway Route_table Creation
resource "aws_ec2_transit_gateway_route_table" "TGRT" {
  transit_gateway_id = aws_ec2_transit_gateway.mumbai-a.id
}

### AWS Transit Gateway Route Creation
resource "aws_ec2_transit_gateway_route" "vpc2" {
  destination_cidr_block         = "10.10.0.0/16"
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.TGRT.id
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.mumbaia_vpc_attachment.id
}
resource "aws_ec2_transit_gateway_route" "vpc1" {
  destination_cidr_block         = "192.168.0.0/16"
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.TGRT.id
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.mumbaib_vpc_attachment.id
}


###################################################
# Security Group Creation                         #
###################################################
resource "aws_security_group" "sg1" {
  name        = "sg1"
  description = "allow ssh from internet and icmp from 192.168.2.0/24"
  vpc_id      = aws_vpc.vpc1.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8 # the ICMP type number for 'Echo'
    to_port     = 0 # the ICMP code
    protocol    = "icmp"
    cidr_blocks = ["192.168.1.0/24"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }


  tags = {
    Name = "sg1"
    Date = local.CreationDate
    env  = local.environment
  }
}

# Create SG2
resource "aws_security_group" "sg2" {
  name        = "sg2"
  description = "allow ssh from internet and icmp from 10.10.2.0/24"
  vpc_id      = aws_vpc.vpc2.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8 # the ICMP type number for 'Echo'v
    to_port     = 0 # the ICMP code
    protocol    = "icmp"
    cidr_blocks = ["10.10.1.0/24"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "sg2"
    Date = local.CreationDate
    env  = local.environment

  }
}

##########################################################
# Create two vms in each VPCs like public/private facing #
##########################################################

resource "aws_instance" "web1" {
  ami                         = local.ami_id
  instance_type               = "t2.micro"
  associate_public_ip_address = true
  subnet_id                   = aws_subnet.publicsub.id
  vpc_security_group_ids      = [aws_security_group.sg1.id]
  key_name                    = local.keyname
  availability_zone           = "ap-south-1a"
  user_data                   = file("pubvm1.sh")

  tags = {
    Name = "publicvm1"
    Date = local.CreationDate
    env  = local.environment
  }
}

resource "aws_instance" "web2" {
  ami                    = local.ami_id
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.privatesub.id
  vpc_security_group_ids = [aws_security_group.sg1.id]
  key_name               = local.keyname
  availability_zone      = "ap-south-1a"

  tags = {
    Name = "privatevm1"
    Date = local.CreationDate
    env  = local.environment
  }
}
resource "aws_instance" "web3" {
  ami                    = local.ami_id
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.pvtsub.id
  vpc_security_group_ids = [aws_security_group.sg2.id]
  key_name               = local.keyname
  availability_zone      = "ap-south-1b"

  tags = {
    Name = "privatevm2"
    Date = local.CreationDate
    env  = local.environment
  }
}

resource "aws_instance" "web4" {
  ami                         = local.ami_id
  instance_type               = "t2.micro"
  subnet_id                   = aws_subnet.pubsub.id
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.sg2.id]
  key_name                    = local.keyname
  availability_zone           = "ap-south-1b"
  user_data                   = file("pubvm2.sh")

  tags = {
    Name = "publicvm2"
    Date = local.CreationDate
    env  = local.environment
  }
}
