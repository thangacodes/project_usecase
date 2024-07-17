output "instanceid" {
  value = aws_instance.lab_machine.*.id
}

output "apache_server_public_endpoints" {
  value = [
    for ip in range(length(aws_instance.lab_machine)) :
    "http://${aws_instance.lab_machine[ip].public_ip}"
  ]
}
output "apache_server_private_endpoints" {
  value = [
    for ip in range(length(aws_instance.lab_machine)) :
    "http://${aws_instance.lab_machine[ip].private_ip}"
  ]
}