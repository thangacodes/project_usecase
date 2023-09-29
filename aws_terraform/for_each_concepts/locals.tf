locals {
  vpc_cidr       = "192.168.0.0/16"
  lb_name        = "cloudbird-fun"
  lb_type        = "network"
  lb_target_name = "cloudbird-tgp"
  port           = "80"
  protocol       = "HTTP"
  avail_zone     = "ap-south-1a"
}
