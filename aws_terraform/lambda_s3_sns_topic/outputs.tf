output "s3_bucket_arn" {
  value = aws_s3_bucket.evidence_bucket.arn
}

output "lambda_function_arn" {
  value = aws_lambda_function.evidence_check_lambda.arn
}

output "sns_topic_arn" {
  value = aws_sns_topic.evidence_identity_response.arn
}

output "sns_subscription_arn" {
  value = aws_sns_topic_subscription.email_subscription.id
}

output "iam_role_arn" {
  value = aws_iam_role.adsk_lambda_s3_evidence_identity.arn
}
