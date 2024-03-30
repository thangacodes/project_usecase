output "vpc_range" {
  value = aws_vpc.corp.cidr_block
}

output "public-subrange" {
  value = aws_subnet.public.*.cidr_block
}
output "private-subrange" {
  value = aws_subnet.private.*.cidr_block
}

output "pubsubid" {
  value = aws_subnet.public.*.id
}
output "pvtsubid" {
  value = aws_subnet.private.*.id
}

output "sgpid" {
  value = aws_security_group.jenkinssg.id
}