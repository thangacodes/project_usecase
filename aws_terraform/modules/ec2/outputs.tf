output "ec2pubip" {
  value = aws_instance.jenkins.public_ip
}

output "jenkinsendpoint" {
  value = "http://${aws_instance.jenkins.public_ip}:8080/"
}