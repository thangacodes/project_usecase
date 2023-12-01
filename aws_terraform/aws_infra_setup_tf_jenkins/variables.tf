variable "region" {
  type = string
}
variable "ami_id" {
  type = string
}
variable "instance_type" {
  type = string
}
variable "sgp" {
  type = list(string)
}
variable "key_name" {
  type = string
}

variable "all_tag" {
  type = map(any)
  default = {
    Project      = "Example demo"
    CreationDate = "01/12/2023"
    Environment  = "Development"
  }
}
