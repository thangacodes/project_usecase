module "template_files" {
  source = "hashicorp/dir/template"

  base_dir = "${path.module}/web"
}

resource "aws_s3_bucket" "prod_website" {
  bucket_prefix = var.bucket_prefix

  tags = {
    Name         = "my-demo-tf-s3-website-host-bucket"
    Environment  = "development"
    CreationDate = "24/08/2023"
  }
}

resource "aws_s3_bucket_acl" "prod" {
  bucket = aws_s3_bucket.prod_website.id
  acl    = "public-read"
}

resource "aws_s3_bucket_policy" "allow_access" {
  bucket = aws_s3_bucket.prod_website.id
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Sid" : "PublicReadGetObject",
        "Effect" : "Allow",
        "Principal" : "*",
        "Action" : "s3:GetObject",
        "Resource" : "arn:aws:s3:::${aws_s3_bucket.prod_website.id}/*"
      }
    ]
  })
}

resource "aws_s3_bucket_website_configuration" "my_bucket" {
  bucket = aws_s3_bucket.prod_website.id

  index_document {
    suffix = "index.html"
  }
  error_document {
    key = "index.html"
  }
  depends_on = [aws_s3_bucket_acl.prod]
}

resource "aws_s3_object" "hosting_bucket_files" {
  bucket = aws_s3_bucket.prod_website.id

  for_each = module.template_files.files

  key          = each.key
  content_type = each.value.content_type

  source  = each.value.source_path
  content = each.value.content

  etag = each.value.digests.md5
}
