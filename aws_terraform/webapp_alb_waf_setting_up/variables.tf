variable "region" {}
variable "ami_id" {}
variable "vmspec" {}
variable "key" {}
variable "tags" {
  default = {
    Environment  = "Development"
    Owner        = "tm@example.com"
    CostCenter   = "500123"
    Project      = "Infra as Code"
    CreationDate = "07/11/2023"
    TF_Version   = "v1.2.8"
  }
}
variable "cidr_block" {}
variable "pubsub_cidr" {}
variable "pubsub1_cidr" {}
