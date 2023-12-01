output "ec2pubip" {
  value = aws_instance.demo.*.public_ip
}
output "ec2privip" {
  value = aws_instance.demo.*.private_ip
}
