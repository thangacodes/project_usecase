output "lb_dns_name" {
  value = "http://${aws_lb.test.dns_name}"
}
