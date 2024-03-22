### Creating resources like Security_group,Keypair,EC2 instances.

/*local variables for amending key_value*/
locals {
  keystore = "prd/${var.key_name}"
}

/* Creation of Security Group */
resource "aws_security_group" "jenkins" {
  name        = "Jenkins-SecurityGroup"
  description = "HTTP and SSH protocols allowed"
  vpc_id      = aws_vpc.tfvpc.id
  tags        = merge(var.tagging, { Name = "Jenkins-SecurityGroup" })
}
resource "aws_security_group_rule" "egress_out" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.jenkins.id
}
resource "aws_security_group_rule" "inbound_rule1" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.jenkins.id
}
resource "aws_security_group_rule" "inbound_rule2" {
  type              = "ingress"
  from_port         = 8080
  to_port           = 8080
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.jenkins.id
}

/* Fetching AMI ID using Data source */
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

/* To Generate Private Key */
resource "tls_private_key" "rsa_4096" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

/* To Generate Private Key */
resource "aws_key_pair" "sshkey" {
  key_name   = local.keystore
  public_key = tls_private_key.rsa_4096.public_key_openssh
  tags       = merge(var.tagging, { Name = "SSHKEY" })
}

/* Save PEM file locally and change the file permission too */
resource "local_file" "private-key" {
  content  = tls_private_key.rsa_4096.private_key_pem
  filename = var.key_name
  provisioner "local-exec" {
    command = "chmod 400 ${local.keystore}"
  }
}

/* Creation of an EC2 Instance with Jenkins installed */
resource "aws_instance" "jenkins" {
  instance_type = var.instance_type
  ami           = data.aws_ami.amazon-ami.id
  key_name      = aws_key_pair.sshkey.key_name
  #user_data = file("initscript.sh")
  vpc_security_group_ids      = [aws_security_group.jenkins.id]
  subnet_id                   = aws_subnet.public[0].id
  associate_public_ip_address = true
  #  user_data                   = file("init_script.sh")
  availability_zone = data.aws_availability_zones.available.names[0]
  depends_on        = [aws_security_group.jenkins]
  tags              = merge(var.tagging, { Name = "JENKINS-CICD" })
  provisioner "remote-exec" {
    inline = ["echo 'Wait until SSH is ready'"]

    connection {
      type        = "ssh"
      user        = "ec2-user"
      private_key = file("${local.keystore}")
      host        = aws_instance.jenkins.public_ip
    }
  }
  provisioner "local-exec" {
    command = "ansible-playbook -i ${aws_instance.jenkins.public_ip}, --private-key ${local.keystore} ../jenkins.yml"
  }
}