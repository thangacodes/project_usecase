locals {
  availability_zone = "ap-south-1a"
}

resource "aws_instance" "jenkins" {
  ami               = var.ami_id
  instance_type     = var.instance_spce
  security_groups   = [var.sgpid]
  subnet_id         = var.subid
  key_name          = var.sshkey
  availability_zone = local.availability_zone
  tags = {
    Name = "Jenkins-cicd"
  }
}