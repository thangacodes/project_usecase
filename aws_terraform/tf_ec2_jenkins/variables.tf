variable "region" {
  type        = string
  default     = "ap-south-1"
  description = "The place where in we deploy/manage resources in AWS"
}
variable "vpc_cidr" {
  type        = string
  default     = "172.20.0.0/16"
  description = "VPC CIDR ip range"
}
variable "public_subnet1" {
  type        = string
  default     = "172.20.10.0/24"
  description = "Public Subnet ip range"
}
variable "private_subnet1" {
  type        = string
  default     = "172.20.20.0/24"
  description = "Private Subnet ip range"
}
variable "identity" {
  type = map(string)
  default = {
    CreationDate = "28/08/2023"
    Environment  = "Development"
    Owner        = "Thangadurai.Murugan@example.com"
    Tfversion    = "~> 5.0"
    Costcenter   = "100000"
    Reason       = "assesment"
    Company      = "Example.com"
  }
}
