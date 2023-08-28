locals {
  ami     = "ami-012b9156f755804f5"
  vm_size = "t2.micro"
  sgpid   = ["${aws_security_group.public.id}"]
}
