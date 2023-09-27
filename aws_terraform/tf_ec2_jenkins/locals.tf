locals {
  vm_size    = "t2.micro"
  sgpid      = ["${aws_security_group.public.id}"]
  avail_zone = "ap-south-1"
}
