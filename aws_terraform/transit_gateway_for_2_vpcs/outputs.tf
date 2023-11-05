output "vm1_pubip" {
  value = aws_instance.vpc-1-webvm.public_ip
}
output "vm2_pubip" {
  value = aws_instance.vpc-2-webvm.public_ip
}
output "vm1_privateip" {
  value = aws_instance.vpc-1-webvm.private_ip
}
output "vm2_privateip" {
  value = aws_instance.vpc-2-webvm.private_ip
}
output "web1_pub_endpoint" {
  value = "http://${aws_instance.vpc-1-webvm.public_ip}:80/"
}
output "web2_pub_endpoint" {
  value = "http://${aws_instance.vpc-2-webvm.public_ip}:80/"
}

output "web1_pvt_endpoint" {
  value = "http://${aws_instance.vpc-1-webvm.private_ip}:80/"
}
output "web2_pvt_endpoint" {
  value = "http://${aws_instance.vpc-2-webvm.private_ip}:80/"
}
