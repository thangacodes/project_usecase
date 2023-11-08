variable "region" {}
variable "ami_id" {}
variable "vmspec" {}
variable "key" {}
variable "cidr_block" {}
variable "pubsub_cidr" {}
variable "pubsub1_cidr" {}
variable "avail_zone1" {}
variable "avail_zone2" {}
variable "http_port" {}
variable "instance_count" {}
variable "tags" {
  default = {
    Environment  = "Development"
    Owner        = "tm@example.com"
    CostCenter   = "500123"
    Project      = "Infra_Build"
    CreationDate = "07/11/2023"
    TF_Version   = "v1.2.8"
    application  = "Apache-Web"
  }
}
