output "vmname_fetching" {
  value = ["$aws_instance.web[*].name}"]
}
output "vmpublicip" {
  value = ["$aws_instance.web[*].public_ip}"]
}
output "vmprivateip" {
  value = ["$aws_instance.web[*].private_ip}"]
}
output "machinetype" {
  value = ["$aws_instance.web[*].instance_type}"]
}

output "vpcrange" {
  value = aws_vpc.lab.cidr_block
}
output "pvtcidr" {
  value = ["$aws_subnet.private[*].cidr_block"]
}

output "publiccidr" {
  value = ["$aws_subnet.public[*].cidr_block"]
}
