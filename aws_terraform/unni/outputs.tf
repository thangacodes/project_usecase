output "vm_publicip" {
  value = aws_instance.mywork.public_ip
}
output "vm_privateip" {
  value = aws_instance.mywork.private_ip
}

output "ami_id" {
  value = data.aws_ami.amazon-ami.id
}
