output "webpubip" {
  value = aws_instance.web.public_ip
}
output "webpvtip" {
  value = aws_instance.web.private_ip
}
output "webname" {
  value = aws_instance.web.arn
}
output "amiid" {
  value = aws_instance.web.ami
}
output "bucketname" {
  value = aws_s3_bucket.webs3.website_endpoint
}
output "s3name" {
  value = "Created bucket arn is: ${aws_s3_bucket.webs3.arn}"
}
