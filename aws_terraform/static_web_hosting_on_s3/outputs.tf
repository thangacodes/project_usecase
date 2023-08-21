output "s3_name_finding" {
  value = aws_s3_bucket.mystaticweb.bucket
}

output "index_page_url" {
  value = "http://${aws_s3_bucket.mystaticweb.website_endpoint}/index.html"
}
output "error_page_url" {
  value = "http://${aws_s3_bucket.mystaticweb.website_endpoint}/error.html"
}
