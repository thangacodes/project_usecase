output "vault_db_username_secret" {
  value     = data.vault_generic_secret.vault_db_username.data_json
  sensitive = true
}

output "vault_db_password_secret" {
  value     = data.vault_generic_secret.vault_db_password.data_json
  sensitive = true
}

output "vault_instance_publicip" {
  value = aws_instance.vault-demo.public_ip
}
