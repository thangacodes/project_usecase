provider "aws" {
  region = "ap-south-1"
}

variable "users" {
  type        = list(string)
  description = "Functional accounts for an applications"
  default     = ["svc-func-acc-1", "svc-func-acc-2", "svc-func-acc-3"]
}

resource "aws_iam_user" "svc" {
  count = 3
  name  = var.users[count.index]
}

output "user_names" {
  value = aws_iam_user.svc[*].name
}
