output "public_subnet_cidrs" {
  value = [for subnet in aws_subnet.pubsubnet : subnet.cidr_block]
}

output "private_subnet_cidrs" {
  value = [for subnet in aws_subnet.pvtsubnet : subnet.cidr_block]
}
