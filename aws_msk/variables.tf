variable "region" {}
variable "access_key" {}
variable "secret_access_key" {}
variable "sgp" {}
variable "keypair" {}
variable "vmspec" {}
variable "cluster_name" {}
variable "kafka_version" {}
variable "kafka_ins_type" {}
variable "security_groups" {
  description = "List of security group IDs"
  type        = list(string)
}
variable "tagging" {}
