output "vpcid" {
  value = aws_vpc.myvpc.id
}
output "publicsubnetids" {
  value = aws_subnet.public.*.id
}
output "privatesubnetids" {
  value = aws_subnet.private.*.id
}
output "find_tagvalue" {
  value = local.tagging
}
output "igwid" {
  value = aws_internet_gateway.igw.id
}
