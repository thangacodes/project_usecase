### Creating ec2 instance to perform depends on concept
resource "aws_instance" "web" {
  ami                    = local.image_id
  instance_type          = local.vm_size
  key_name               = local.sshkey
  vpc_security_group_ids = [local.secgp]
  tags                   = merge(var.identity, { Name = "Tomcatbox" })
}

resource "aws_s3_bucket" "webs3" {
  bucket     = local.s3name
  tags       = merge(var.identity, { Name = "Anvikhadads3bucket" })
  depends_on = [aws_instance.web]
}
