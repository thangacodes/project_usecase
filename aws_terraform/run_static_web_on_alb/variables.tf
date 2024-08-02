# Variables block

variable "common_tag" {
  description = "Service tags that are associated with each resource that we provision"
}

variable "vpc_range" {
  description = "This is the IP range that we are using it to configure entire network"
}

variable "pvtcidr" {
  description = "This is for private subnet cidr range"
  type        = list(string)
}

variable "pubcidr" {
  description = "This is for public subnet cidr range"
  type        = list(string)
}

variable "region" {
  description = "The region where we provision the services"
}

variable "vmspec" {
  description = "Virtual machine size interms of CPU/memory"
}
