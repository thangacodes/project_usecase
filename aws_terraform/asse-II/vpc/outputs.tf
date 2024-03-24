output "vpcid" {
  value = aws_vpc.labnw.id
}

output "subid" {
  value = aws_subnet.public.id
}

output "sgpid" {
  value = aws_security_group.jenkinssg.id
}