output "macpubdns" {
  value = "http://${aws_instance.mac-vm.public_dns}:8080/"
}

output "macpubip" {
  value = "http://${aws_instance.mac-vm.public_ip}:8080/"
}

output "macpvtip" {
  value = aws_instance.mac-vm.private_ip
}
