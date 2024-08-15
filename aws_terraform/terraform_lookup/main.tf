## Fetch the Ubuntu AMI
data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  owners = ["099720109477"]
}

## Fetch the Default VPC
data "aws_vpc" "default" {
  default = true
}

## Use the Default VPC
resource "aws_security_group" "onlyinbound" {
  name        = "web-sgp"
  description = "Allow SSH and HTTP port at inbound rule"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    description = "SSH from VPC"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [data.aws_vpc.default.cidr_block]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = merge(var.identification, { Name = "web-sgp" })
}

## Use the Default VPC
resource "aws_instance" "web" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = lookup(var.instance_type, "sandbox", "t2.micro")
  key_name               = lookup(var.sshkey, "sandbox", "dwebkey")
  vpc_security_group_ids = [aws_security_group.onlyinbound.id]
  tags                   = merge(var.identification, { Name = "vm-testing" })
}
