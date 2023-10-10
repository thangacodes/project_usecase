resource "aws_iam_user" "functional" {
  count = length(var.user_names)
  name  = var.user_names[count.index]
  tags  = merge(var.tagging, { Name = var.user_names[count.index] })
}
