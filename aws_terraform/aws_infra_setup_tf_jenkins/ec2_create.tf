resource "aws_instance" "demo" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  vpc_security_group_ids = var.sgp
  key_name               = var.key_name
  count                  = 1
  user_data              = file("./script.sh")
  tags                   = merge(var.all_tag, { Name = "demo-dev-app-server" })
}

# Retrieve the list of AZs in the current AWS region
data "aws_availability_zones" "available" {}
data "aws_region" "current" {}
