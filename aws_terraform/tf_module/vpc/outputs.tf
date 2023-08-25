output "vpc_id" {
  description = "VPC ID"
  value       = module.vpc.vpc_id
}

# output "pvt_subnet_cidr" {
#   description = "Private Subnet CIDR"
#   value       = module.vpc.private_subnets.*.cidr_block
# }

# output "pub_subnet_cidr" {
#   description = "Public Subnet CIDR"
#   value       = module.vpc.public_subnets.*.cidr_block
# }
