output "vpc_cidr" {
  value = aws_vpc.demovpc.cidr_block
}

output "publicsubnetcidr" {
  value = aws_subnet.public.*.cidr_block
}

output "privatesubnetcidr" {
  value = aws_subnet.private.*.cidr_block
}

output "igwid" {
  value = aws_internet_gateway.igw.id
}

output "tagnames" {
  value = var.tagging
}
