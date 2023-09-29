variable "region" {
  description = "The place where our infra should be present in AWS"
  type        = string
  default     = "ap-south-1"
}
variable "identify" {
  type = map(string)
  default = {
    Application  = "Cloudbird fun"
    Environment  = "Development"
    Owner        = "test@example.com"
    CreationDate = "28/09/2023"
    Costcentre   = "1000234"
    Tf_version   = "v1.2.8"
    aws_version  = "5.18.1"
  }
}
variable "public_subnet_range" {
  description = "Public Subnet CIDR values"
  type        = map(string)
  default     = { public-subnet1 = "192.168.1.0/24", public-subnet2 = "192.168.2.0/24", public-subnet3 = "192.168.3.0/24" }
}
variable "private_subnet_range" {
  description = "Private Subnet CIDR values"
  type        = map(string)
  default     = { private-subnet1 = "192.168.4.0/24", private-subnet2 = "192.168.5.0/24", private-subnet3 = "192.168.6.0/24" }
}
