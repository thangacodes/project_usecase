variable "region" {
  default     = "ap-south-1"
  description = "The location on which we create aws services"
  type        = string
}

variable "identity" {
  default = {
    CreationDate = "24/08/2023"
    Environment  = "Development"
    costcentre   = "1000567"
    Owner        = "Thangadurai.Murugan@grabtech.com"
    Organization = "Grabtech.com"
  }
}
