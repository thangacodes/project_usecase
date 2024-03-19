### Fetching the values in Output

output "vpc_iprange" {
  value = aws_vpc.tfvpc.cidr_block
}
output "privatesubnet_iprange" {
  value = aws_subnet.private.*.cidr_block
}
output "publicsubnet_iprange" {
  value = aws_subnet.public.*.cidr_block
}

output "common_tags" {
  value = aws_vpc.tfvpc.tags_all
}

output "serverip" {
  value = aws_instance.jenkins.public_ip
}

output "serverloginkey" {
  value = aws_instance.jenkins.key_name
}
output "jenkins_endpoint" {
  value = "http://${aws_instance.jenkins.public_ip}"
}
