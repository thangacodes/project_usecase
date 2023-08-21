# Create S3 bucket
resource "aws_s3_bucket" "mystaticweb" {
  bucket = var.s3_name

  tags = {
    Name         = "${var.s3_name}"
    Environment  = "Development"
    CreationDate = "08-08-2023"
    Project      = "Static_Website_Deployment"
  }
}

### aws_s3_bucket_ownership_controls
resource "aws_s3_bucket_ownership_controls" "mine" {
  bucket = aws_s3_bucket.mystaticweb.id

  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

#### aws_s3_bucket_public_access_block
resource "aws_s3_bucket_public_access_block" "mine" {
  bucket = aws_s3_bucket.mystaticweb.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

### aws_s3_bucket_acl
resource "aws_s3_bucket_acl" "mine" {
  depends_on = [aws_s3_bucket_ownership_controls.mine]

  bucket = aws_s3_bucket.mystaticweb.id
  acl    = "public-read"
}

### aws_s3_bucket_website_configuration
resource "aws_s3_object" "index" {
  bucket       = aws_s3_bucket.mystaticweb.id
  key          = "index.html"
  source       = "index.html"
  acl          = "public-read"
  content_type = "text/html"
}

resource "aws_s3_object" "error" {
  bucket       = aws_s3_bucket.mystaticweb.id
  key          = "error.html"
  source       = "error.html"
  acl          = "public-read"
  content_type = "text/html"
}

resource "aws_s3_object" "profile" {
  bucket = aws_s3_bucket.mystaticweb.id
  key    = "devops.PNG"
  source = "devops.PNG"
  acl    = "public-read"
}

###### aws_s3_bucket_website_configuration
resource "aws_s3_bucket_website_configuration" "webconfig" {
  bucket = aws_s3_bucket.mystaticweb.id
  index_document {
    suffix = "index.html"
  }
  error_document {
    key = "error.html"
  }
  depends_on = [aws_s3_bucket_acl.mine]
}                                                                                                                                                                        ii
