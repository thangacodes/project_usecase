output "user_details" {
  value = [for u in aws_iam_user.functional : u.name]
}
