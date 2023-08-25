output "website_url" {
  description = "URL of the website"
  value       = aws_s3_bucket_website_configuration.my_bucket.website_endpoint
}
