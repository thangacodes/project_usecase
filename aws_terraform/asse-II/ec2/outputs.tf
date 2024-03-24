output "instance_pubip" {
  value = aws_instance.jenkins.public_ip
}

output "jenkins_endpoint" {
  value = "http://${aws_instance.jenkins.public_ip}:8080/"
}