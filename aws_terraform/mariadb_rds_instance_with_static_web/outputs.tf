output "macpubip" {
  value = aws_instance.mac-vm.public_ip
}

output "macpubdns" {
  value = "http://${aws_instance.mac-vm.public_dns}:8080/"
}

output "macpvtip" {
  value = aws_instance.mac-vm.private_ip
}

output "mariadb_endpoint" {
  value = aws_db_instance.mariadb.endpoint
}

output "mariadb_password" {
  value     = data.aws_secretsmanager_secret_version.secret.secret_string
  sensitive = true
}
