resource "aws_instance" "vm" {
  ami                         = local.default.ami_id
  instance_type               = lookup(var.ins_type, var.user_input, "t2.micro")
  vpc_security_group_ids      = local.default.sgp
  key_name                    = local.default.keyname
  associate_public_ip_address = true
  user_data                   = file("bootstrap.sh")
  availability_zone           = local.default.avail_zone
  tags                        = merge(var.tagging, { Name = "Lookup_VM" })
}

## S3 bucket creation
resource "aws_s3_bucket" "s3" {
  bucket = lower(local.default.bucket_name)
  tags   = merge(var.tagging, { Name = lower(local.default.bucket_name) })
}
