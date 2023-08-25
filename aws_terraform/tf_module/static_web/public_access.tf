### aws_s3_bucket_ownership_controls
resource "aws_s3_bucket_ownership_controls" "mine" {
  bucket = aws_s3_bucket.prod_website.id

  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

#### aws_s3_bucket_public_access_block
resource "aws_s3_bucket_public_access_block" "mine" {
  bucket                  = aws_s3_bucket.prod_website.id
  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

