locals {
  tagging = {
    Environment  = "Development"
    CreationDate = "12/08/2024"
    Project      = "Cloudbird"
    Owner        = "thangadurai.murugan@cloudbird.fun"
  }
  bombay_ami = "ami-0a4408457f9a03be3"
  vm_spec    = "t2.micro"
  vm_sgp     = ["sg-0fb1052b659369aa8"]
  ssh_key    = "mac"
  region     = "ap-south-1"
}

resource "aws_instance" "web" {
  ami                         = local.bombay_ami
  instance_type               = local.vm_spec
  key_name                    = local.ssh_key
  vpc_security_group_ids      = local.vm_sgp
  associate_public_ip_address = false
  tags                        = merge(local.tagging, { Name = "local-var-ec2" })
}
