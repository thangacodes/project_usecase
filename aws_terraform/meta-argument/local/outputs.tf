output "tag_details" {
  value = aws_instance.web.tags_all
}

output "vm_amiid" {
  value = aws_instance.web.ami
}

output "vm_privateip" {
  value = aws_instance.web.private_ip
}

output "vm_secgp_name" {
  value = "The NAME of the security group associated with the VM is/are: ${join(", ", aws_instance.web.security_groups)}"
}

output "vm_secgp_ids" {
  value = "The ID of the security group associated with the VM is/are: ${join(", ", aws_instance.web.vpc_security_group_ids)}"
}
