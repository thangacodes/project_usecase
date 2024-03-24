resource "aws_vpc" "labnw" {
  cidr_block = var.vpc_cidr
  tags = {
    Name = "My_vpc"
  }
}

resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.labnw.id
  cidr_block              = var.pub_cidr
  map_public_ip_on_launch = true
  availability_zone       = "ap-south-1a"
  tags = {
    Name = "Public-Subnet"
  }
}

resource "aws_security_group" "jenkinssg" {
  vpc_id = aws_vpc.labnw.id
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