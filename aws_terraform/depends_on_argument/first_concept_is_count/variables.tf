variable "region" {
  default     = "ap-south-1"
  description = "The place where you are creating your Infra services"
  type        = string
}

variable "tagging" {
  default = {
    CreationDate = "24/08/2023"
    Owner        = "Thangadurai.murugan@grabtech.com"
    CostId       = "1000345"
  }
}
