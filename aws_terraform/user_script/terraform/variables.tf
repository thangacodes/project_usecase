variable "servername" {
  default = ""
}

variable "region" {
  default = "ap-south-1"
}

variable "sgp" {
  default = "sg-0fb1052b659369aa8"
}

variable "sshkey" {
  default = "practical"
}

variable "vmspec" {
  default = "t2.micro"
}

variable "tagging" {
  default = {
    CreationDate = "07/16/2024"
    Environment  = "lab"
    Owner        = "thangadurai.murugan@example.com"
    ProjectName  = "blockbox-poc"
    TFversion    = "v1.9.1"
  }
}