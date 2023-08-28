output "jenkin-vm-pubip" {
  value = aws_instance.jenkins.public_ip
}
output "jenkin-vm-pvtip" {
  value = aws_instance.jenkins.private_ip
}
output "jenkin-vm-endpoint" {
  value = "http://${aws_instance.jenkins.public_ip}:8080/"
}
