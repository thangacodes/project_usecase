variable "region" {
  default     = "ap-south-1"
  type        = string
  description = "The region where do you want to spinup services in aws"
}
variable "ins_type" {
  type        = map(string)
  description = "Specifying vm type"
  default = {
    "dev"   = "t2.micro"
    "test"  = "t3.micro"
    "stage" = "c5.large"
    "ppe"   = "m4.large"
    "prod"  = "m5.xlarge"
  }
}
variable "user_input" {
  type        = string
  description = "This is the default value taken by the tf script"
}

variable "tagging" {
  default = {
    Environment  = "Development"
    CreationDate = "02/10/2023"
    Owner        = "Thangadurai.murugan@cloudbird.fun"
    TFVersion    = "1.5.7"
    AWS_TFV      = "5.19.0"
  }
}
