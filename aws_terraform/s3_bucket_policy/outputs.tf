output "bucket_name" {
  value = aws_s3_bucket.tdweb.bucket_domain_name
}

output "bucket_id" {
  value = aws_s3_bucket.tdweb.arn
}
