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
