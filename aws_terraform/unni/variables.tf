##### Variables
variable "region" {
  description = "The region where the services will be getting created"
}
variable "instance_type" {
  description = "Vm specification"
}
variable "tagging" {
  description = "VM tagging section"
}
variable "key_name" {
  description = "Custom SSH keypair creation"
}
