output "ECR_instance_pubip" {
  value = aws_instance.ecr_ec2.*.public_ip
}

output "ECR_instance_pvtip" {
  value = aws_instance.ecr_ec2.*.private_ip
}

output "App_publicip_endpoint" {
  value = "http://${aws_instance.ecr_ec2[0].public_ip}:80/"
}

output "App_privateip_endpoint" {
  value = "http://${aws_instance.ecr_ec2[0].private_ip}:80/"
}

output "ECR_security_group_id" {
  value = aws_security_group.ecr-sgp.id
}
output "ECR_security_group_name" {
  value = aws_security_group.ecr-sgp.name
}
output "ECR-security_group_arn" {
  value = aws_security_group.ecr-sgp.arn
}

output "ECR_ALB_id" {
  value = aws_lb_listener.front_end.id
}

output "ECR_ALB_dnsname" {
  value = aws_lb.LoadBalancer.dns_name
}

output "ECR_ALB_internal" {
  value = aws_lb.LoadBalancer.internal
}