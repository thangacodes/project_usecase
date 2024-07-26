### Simple EC2 creation
resource "aws_instance" "mac-vm" {
  instance_type          = var.instance_type
  ami                    = var.ami
  key_name               = var.key_name
  vpc_security_group_ids = [var.sgp]
  tags                   = merge(var.tagging, { Name = "Mac-VM" })
}
