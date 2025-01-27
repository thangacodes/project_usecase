variable "aws_profile_name" {}
variable "region" {}
variable "filename" {}
variable "bucket_name" {}
variable "role_name" {}
variable "topic_name" {}
variable "protocol" {}
variable "mail_endpoint" {}
variable "runtime" {}
variable "handler" {}
variable "is_destroy" {
  description = "A flag to determine whether to destroy the S3 bucket"
  type        = bool
  default     = false
}
