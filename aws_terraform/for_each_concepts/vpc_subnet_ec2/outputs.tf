output "vpc_ids" {
  value = [for vpc in aws_vpc.multi_vpc_creation : vpc.id]
}

output "dev_subnet_ids" {
  value = [for subnet in aws_subnet.dev_private_subnets : subnet.id]
}

output "stage_subnet_ids" {
  value = [for subnet in aws_subnet.stage_private_subnets : subnet.id]
}

output "prod_subnet_ids" {
  value = [for subnet in aws_subnet.prod_private_subnets : subnet.id]
}

output "all_igw_ids" {
  value = [for igw in aws_internet_gateway.multi_igw : igw.id]
}

output "ec2_ids" {
  value = [for ec2 in aws_instance.multi_ec2 : ec2.id]
}
