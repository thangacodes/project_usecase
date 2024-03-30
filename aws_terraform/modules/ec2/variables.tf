variable "amiid" {
  default = "ami-05295b6e6c790593e"
}

variable "vmspec" {
  default = "t2.micro"
}

variable "key" {
  default = "tfuser"
}

variable "tagging" {
  default = {
    Environment  = "dev"
    Owner        = "thangadurai.murugan@example.com"
    creationdate = "30/03/2024"
  }
}
variable "publicsubid" {}
variable "sgpid" {}