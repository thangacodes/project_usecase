output "role_arn" {
  value = aws_iam_role.lambda_invocation_role.arn
}

output "policy_arn" {
  value = aws_iam_policy.s3_read_policy.arn
}
output "lambda_function_arn" {
  value = aws_lambda_function.first_lambda_function.arn
}

output "iam_role_arn" {
  value = aws_iam_role.lambda_invocation_role.arn
}
# Output the Lambda invocation result
output "lambda_invocation_result" {
  value = data.aws_lambda_invocation.test_lambda.result
}
