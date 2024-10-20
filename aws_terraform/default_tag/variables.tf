variable "region" {
  default     = "ap-south-1"
  description = "The resource that you are going to provision AWS region"
}

variable "aws_access_key" {
  type        = string
  description = "AWS API ACCESS_KEY"
  default     = "***************"
}

variable "aws_secret_key" {
  type        = string
  description = "AWS API SECRET_ACCESS_KEY"
  default     = "***********************************"
}

variable "ami_id" {
  default     = "ami-04a37924ffe27da53"
  description = "Image to provision EC2 Machine in AWS Cloud"
}

variable "instance_type" {
  default     = "t2.micro"
  description = "Type that we provision as EC2 Machine in AWS Cloud"
}

variable "sgp" {
  default     = ["sg-0fb1052b659369aa8"]
  description = "Virtual Firewall for EC2 machine"
}

variable "sshkey" {
  default     = "mac"
  description = "Virutally connect remote machine via SSH key"
}
