output "web1pubip" {
  value = aws_instance.web1.public_ip
}
output "web1pvtip" {
  value = aws_instance.web1.private_ip
}
output "web2pvtip" {
  value = aws_instance.web2.private_ip
}
output "web3pvtip" {
  value = aws_instance.web3.private_ip
}
output "web4pvtip" {
  value = aws_instance.web4.private_ip
}
output "web4pubip" {
  value = aws_instance.web4.public_ip
}

output "web1endpoint" {
  value = "http://${aws_instance.web1.public_ip}:80/"
}

output "web4endpoint" {
  value = "http://${aws_instance.web4.public_ip}:80/"
}

output "vpc1pubsubrange" {
  value = aws_subnet.publicsub.cidr_block
}

output "vpc1pvtsubrange" {
  value = aws_subnet.privatesub.cidr_block
}

output "vpc2pubsubrange" {
  value = aws_subnet.pubsub.cidr_block
}

output "vpc2pvtsubrange" {
  value = aws_subnet.pvtsub.cidr_block
}

output "transitgwid" {
  value = aws_ec2_transit_gateway.mumbai-a.id
}

