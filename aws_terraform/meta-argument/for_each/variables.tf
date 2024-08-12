variable "region" {
  description = "The region where you wanna provision the services of aws"
}
variable "vpccidr" {
  description = "VPC IP range"
}
variable "tagging" {
  description = "All the resources tagging for identification"
}
variable "pubsub" {
  description = "List of subnet configurations with names and CIDR blocks"
  type = list(object({
    name = string
    cidr = string
  }))
}

variable "pvtsub" {
  description = "List of subnet configurations with names and CIDR blocks"
  type = list(object({
    name = string
    cidr = string
  }))
}
