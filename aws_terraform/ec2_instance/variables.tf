variable "region" {
  default     = "ap-south-1"
  description = "Region on which the services will be provisioned"
}

variable "ami" {
  default     = "ami-068e0f1a600cd311c"
  description = "Base amazon machine image"
}

variable "instance_type" {
  default     = "t2.micro"
  description = "VM specification"
}

variable "key_name" {
  default     = "mac"
  description = "To connect vm via putty or terminal"
}

variable "sgp" {
  default     = "sg-0fb1052b659369aa8"
  description = "Virtual firewall for an EC2 machine"
}

variable "tagging" {
  default = {
    CreationDate = "26/07/2024"
    Owner        = "admin@example.com"
    Project      = "Blueduck"
    Costcenter   = "1200345"
  }
}
