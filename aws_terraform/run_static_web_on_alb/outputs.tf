output "publicendpoints" {
  value = [for i in aws_instance.labvm : "http://${i.public_ip}:80/"]
}

output "alb_endpint" {
  value = "http://${aws_lb.labalb.dns_name}"
}

output "alb_arn" {
  value = aws_lb.labalb.arn
}
output "module_path" {
  value = path.module
}
