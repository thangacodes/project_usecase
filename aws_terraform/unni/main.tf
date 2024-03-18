### Creating resources like Security_group,Keypair,EC2 instances.

## Fetching default VPC id values
data "aws_vpc" "default" {
  default = true
}

### Security Group creation
resource "aws_security_group" "public" {
  name        = "Jenkins-SGP"
  description = "HTTP and SSH protocols allowed"
  vpc_id      = data.aws_vpc.default.id
  tags        = merge(var.tagging, { Name = "Jenkins-SecurityGroup" })
}

resource "aws_security_group_rule" "egress_out" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.public.id
}

resource "aws_security_group_rule" "inbound_rule1" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.public.id
}

resource "aws_security_group_rule" "inbound_rule2" {
  type              = "ingress"
  from_port         = 8080
  to_port           = 8080
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.public.id
}

resource "aws_instance" "mywork" {
  instance_type               = var.instance_type
  ami                         = data.aws_ami.amazon-ami.id
  key_name                    = aws_key_pair.key.key_name
  vpc_security_group_ids      = [aws_security_group.public.id]
  associate_public_ip_address = true
  user_data                   = file("init_script.sh")
  depends_on                  = [aws_security_group.public]
  tags                        = merge(var.tagging, { Name = "JENKINS-BOX" })
}

### AMI ID fetching
data "aws_ami" "amazon-ami" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-kernel-5.10-hvm-2.0.20240306.2-x86_64-gp2"]
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

// To Generate Private Key
resource "tls_private_key" "rsa_4096" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

// Create Key Pair for Connecting EC2 via SSH
resource "aws_key_pair" "key" {
  key_name   = var.key_name
  public_key = tls_private_key.rsa_4096.public_key_openssh
  tags       = merge(var.tagging, { Name = "jenkins" })
}

// Save PEM file locally and change the file permission too
resource "local_file" "private-key" {
  content  = tls_private_key.rsa_4096.private_key_pem
  filename = var.key_name
  provisioner "local-exec" {
    command = "chmod 400 ${var.key_name}"
  }
}
