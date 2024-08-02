## VPC Creation
resource "aws_vpc" "lab" {
  cidr_block = var.vpc_range
  tags       = merge(var.common_tag, { Name = "Lab_vpc" })
}

## Internet Gateway Creation
resource "aws_internet_gateway" "lab" {
  vpc_id = aws_vpc.lab.id
  tags   = merge(var.common_tag, { Name = "Lab_vpc_igw" })
}

## Subnet Creation
resource "aws_subnet" "lab-pvt" {
  vpc_id     = aws_vpc.lab.id
  count      = length(var.pvtcidr)
  cidr_block = var.pvtcidr[count.index]
  tags       = merge(var.common_tag, { Name = "Lab-Private-Subnet-${count.index + 1}" })
}

resource "aws_subnet" "lab-pub" {
  vpc_id                  = aws_vpc.lab.id
  count                   = length(var.pubcidr)
  cidr_block              = var.pubcidr[count.index]
  map_public_ip_on_launch = true
  tags                    = merge(var.common_tag, { Name = "Lab-Public-Subnet-${count.index + 1}" })
}

# Route Table Creation - Public/Private RT
resource "aws_route_table" "pub-rt" {
  vpc_id = aws_vpc.lab.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.lab.id
  }
  tags = merge(var.common_tag, { Name = "Public-RT" })
}

resource "aws_route_table_association" "pub-sub-associ" {
  count          = length(aws_subnet.lab-pub)
  subnet_id      = aws_subnet.lab-pub[count.index].id
  route_table_id = aws_route_table.pub-rt.id
}

resource "aws_route_table" "pvt-rt" {
  vpc_id = aws_vpc.lab.id
  tags   = merge(var.common_tag, { Name = "Private-RT" })
}

resource "aws_route_table_association" "pvt-sub-associ" {
  count          = length(aws_subnet.lab-pvt)
  subnet_id      = aws_subnet.lab-pvt[count.index].id
  route_table_id = aws_route_table.pvt-rt.id
}

## EC2 machine creation
resource "aws_instance" "labvm" {
  ami                    = data.aws_ami.amazon-ami.id
  instance_type          = var.vmspec
  key_name               = aws_key_pair.labkey.id
  user_data              = file("userdata.sh")
  vpc_security_group_ids = [aws_security_group.labsg.id]
  count                  = 2
  subnet_id              = aws_subnet.lab-pub[0].id
  tags                   = merge(var.common_tag, { Name = "ApacheWeb-Server-${count.index + 1}" })
}

## Dynamically fetching ami_id using datasource
data "aws_ami" "amazon-ami" {
  most_recent = true
  owners      = ["137112412989"]
  filter {
    name   = "name"
    values = ["amzn2-ami-kernel-5.10-hvm-2.0.20240719.0-x86_64-gp2"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "tls_private_key" "privatekey" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "labkey" {
  key_name   = "SSHKEY"
  public_key = tls_private_key.privatekey.public_key_openssh
}

resource "local_file" "key" {
  filename = "${path.module}/SSH.pem"
  content  = tls_private_key.privatekey.private_key_pem
}

## Security Group Creation
resource "aws_security_group" "labsg" {
  name        = "lab_security_group"
  description = "Allow HTTP/HTTPS and SSH protocol as ingress"
  vpc_id      = aws_vpc.lab.id
  ingress {
    description = "SSH ingress"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "HTTP ingress"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTPS ingress"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = merge(var.common_tag, { Name = "lab-sgp" })
}

### Target group and ALB Creation 
resource "aws_lb_target_group" "labtgp" {
  name        = "static-web-tgp"
  target_type = "instance"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = aws_vpc.lab.id
  health_check {
    path = "/"
  }
  tags = merge(var.common_tag, { Name = "Static-Web-TGP" })
}

resource "aws_lb_target_group_attachment" "lab-attach" {
  count            = length(aws_instance.labvm)
  target_id        = aws_instance.labvm[count.index].id
  target_group_arn = aws_lb_target_group.labtgp.arn
  port             = 80
}

resource "aws_lb" "labalb" {
  name                       = "static-web-alb"
  internal                   = false
  load_balancer_type         = "application"
  security_groups            = [aws_security_group.labsg.id]
  subnets                    = [for subnet in aws_subnet.lab-pub : subnet.id]
  enable_deletion_protection = true
  tags                       = merge(var.common_tag, { Name = "Static-Web-ALB" })
}

resource "aws_lb_listener" "lab_http_listner" {
  load_balancer_arn = aws_lb.labalb.arn
  port              = "80"
  protocol          = "HTTP"
  default_action {
    target_group_arn = aws_lb_target_group.labtgp.id
    type             = "forward"
  }
}
