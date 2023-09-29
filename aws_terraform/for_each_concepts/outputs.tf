output "vpciprange" {
  value = aws_vpc.cloudbird.cidr_block
}
output "pubsubnetrange" {
  value = [for i in aws_subnet.public : i.cidr_block]
}
output "pvtsubnetrange" {
  value = [for j in aws_subnet.private : j.cidr_block]
}
output "elasticip" {
  value = aws_eip.natip.address
}
