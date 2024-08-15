output "vmspec" {
  value = aws_instance.web.instance_type
}

output "vm_tags" {
  value = aws_instance.web.tags_all
}

output "keyfinding" {
  value = aws_instance.web.key_name
}

output "sgp_finding" {
  value = aws_instance.web.security_groups
}

output "vm_privateip" {
  value = aws_instance.web.private_ip
}

output "vm_publicip" {
  value = aws_instance.web.public_ip
}
