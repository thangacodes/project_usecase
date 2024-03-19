/* Variables declaration */

variable "region" {
  type = string
}

variable "tagging" {
  type = map(string)
}

variable "vpc_cidr" {
  type = string
}

variable "private_subnetcidrs" {
  type = list(string)
}

variable "public_subnetcidrs" {
  type = list(string)
}

variable "instance_type" {
  type = string
}
variable "key_name" {
  type = string
}
