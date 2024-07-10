# Define S3 bucket
resource "aws_s3_bucket" "tdweb" {
  bucket = "tdwebsite-files-2024-bucket"
  tags = {
    Name         = "tdwebsite-files-2024-bucket",
    Owner        = "Thangadurai.Murugan@cloudbird.fun",
    CreationDate = "7/9/2024",
    Application  = "Personalweb",
    Product      = "www.cloudbird.fun"
  }
}

# Enable versioning on the S3 bucket
resource "aws_s3_bucket_versioning" "versioning_enable" {
  bucket = aws_s3_bucket.tdweb.id
  versioning_configuration {
    status = "Enabled"
  }
}

# Set bucket ACL to public-read
resource "aws_s3_bucket_acl" "cf_s3_bucket" {
  bucket = aws_s3_bucket.tdweb.id
  acl    = "public-read"
}

# Define bucket policy to restrict access based on IP address
resource "aws_s3_bucket_policy" "public_policy" {
  bucket = aws_s3_bucket.tdweb.id
  policy = <<EOF
{
  "Id": "Policy1720526627688",
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "Stmt1720526625512",
      "Action": "s3:*",
      "Effect": "Allow",
      "Resource": "arn:aws:s3:::tdwebsite-files-2024-bucket/*",
      "Condition": {
        "NotIpAddress": {
          "aws:SourceIp": "152.58.232.40/32"
        }
      },
      "Principal": "*"
    }
  ]
}
EOF
}
