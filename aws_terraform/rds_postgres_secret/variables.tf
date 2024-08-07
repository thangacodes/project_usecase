variable "region" {
  description = "The service that will be provisioned region name"
}
variable "tagging" {}
variable "vpcrange" {}
variable "pub_cidr" {}
variable "pub_cidr2" {}
variable "priv_cidr" {}
variable "db_username" {
  description = "Postgres db username"
  type        = string
}
variable "db_password" {
  description = "Postgres db password"
  type        = string
  sensitive   = true
}
