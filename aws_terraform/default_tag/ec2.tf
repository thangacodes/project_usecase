resource "aws_instance" "tdtag" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  key_name               = var.sshkey
  vpc_security_group_ids = var.sgp
  tags = {
    Name = "Bastion-Host"
  }
}
