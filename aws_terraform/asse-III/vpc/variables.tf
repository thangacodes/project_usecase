variable "vpc_cidr" {
  default = "10.125.0.0/16"
}

variable "tagging" {
  default = {
    Environment  = "Dev"
    Costcenter   = "10003423"
    Owner        = "thangadurai.murugan@example.com"
    CreationDate = "30/03/2024"
  }

}

variable "privatesub" {
  type    = list(string)
  default = ["10.125.1.0/24", "10.125.3.0/24", "10.125.4.0/24"]
}

variable "publicsub" {
  type    = list(string)
  default = ["10.125.2.0/24", "10.125.4.0/24", "10.125.6.0/24"]
}