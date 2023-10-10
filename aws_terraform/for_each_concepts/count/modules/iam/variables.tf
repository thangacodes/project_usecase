variable "region" {
  description = "The place, where we'd like to provision resources"
  type        = string
  default     = "ap-south-1"
}

variable "user_names" {
  description = "iam user creation in AWS"
  type        = list(string)
  default     = ["svc-account1", "svc-account2", "svc-account3"]
}

variable "tagging" {
  default = {
    Environment  = "Sandbox"
    CreationDate = "09/10/2023"
    Owner        = "Thangadurai.murugan@cloudbird.fun"
    TF_version   = "v1.2.8"
    IDE          = "VS Code"
    Usage        = "Functional-accounts"
    Project      = "Apache-web"
  }
}
