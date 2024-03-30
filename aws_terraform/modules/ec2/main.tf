locals {
  az = "ap-south-1a"
}

locals {
  path = path.module
}

resource "aws_instance" "jenkins" {
  ami                    = var.amiid
  instance_type          = var.vmspec
  key_name               = var.key
  user_data              = file("${path.module}/initscript.sh")
  vpc_security_group_ids = [var.sgpid]
  subnet_id              = var.publicsubid[1]
  availability_zone      = local.az
  tags                   = merge(var.tagging, { Name = "CICD" })
}