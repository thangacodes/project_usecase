resource "aws_instance" "vm" {
  ami                    = local.default.ami_id
  instance_type          = lookup(var.ins_type, var.user_input, "t2.micro")
  vpc_security_group_ids = local.default.sgp
  key_name               = local.default.keyname
  availability_zone      = local.default.avail_zone
  tags                   = merge(var.tagging, { Name = "Lookup_VM" })
}
