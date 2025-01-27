# Create S3 Bucket
resource "aws_s3_bucket" "evidence_bucket" {
  bucket = var.bucket_name
  acl    = "private"
}
resource "aws_s3_bucket_notification" "evidence_identity_trigger" {
  bucket = aws_s3_bucket.evidence_bucket.id

  topic {
    topic_arn = aws_sns_topic.evidence_identity_response.arn
    events    = ["s3:ObjectCreated:*"]
  }
  depends_on = [aws_s3_bucket.evidence_bucket, aws_sns_topic.evidence_identity_response]
}

## NULL resource to dynamically create files like test.dll, test.exe, test.zip 
resource "null_resource" "dynamic_files_creation" {
  provisioner "local-exec" {
    command = "bash lambda/malware_file_creation.sh"

  }
  depends_on = [aws_s3_bucket.evidence_bucket]
}

## NULL resource to zip the python script file
resource "null_resource" "making_zip_file" {
  provisioner "local-exec" {
    command = "bash lambda/make_zip.sh"
  }
}

## Lambda function creation
resource "aws_lambda_function" "evidence_check_lambda" {
  function_name    = "evidence_check_lambda"
  role             = aws_iam_role.adsk_lambda_s3_evidence_identity.arn
  handler          = var.handler
  runtime          = var.runtime
  filename         = var.filename
  source_code_hash = filebase64sha256(var.filename)

  environment {
    variables = {
      SNS_TOPIC_ARN      = aws_sns_topic.evidence_identity_response.arn
      TARGET_BUCKET_NAME = var.bucket_name
    }
  }

  depends_on = [null_resource.making_zip_file]
}

# Create SNS Topic
resource "aws_sns_topic" "evidence_identity_response" {
  name = var.topic_name
}
resource "aws_sns_topic_subscription" "email_subscription" {
  protocol  = var.protocol
  endpoint  = var.mail_endpoint
  topic_arn = aws_sns_topic.evidence_identity_response.arn
}

# Create IAM Role with Minimal Permissions for Lambda, S3, and SNS
resource "aws_iam_role" "adsk_lambda_s3_evidence_identity" {
  name = var.role_name
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
        Effect = "Allow"
        Sid    = ""
      }
    ]
  })
}

resource "aws_iam_policy" "lambda_s3_sns_policy" {
  name        = "lambda_s3_sns_policy"
  description = "Lambda policy to access S3 and SNS"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "s3:GetObject",
          "s3:ListBucket"
        ]
        Effect = "Allow"
        Resource = [
          "arn:aws:s3:::${var.bucket_name}",
          "arn:aws:s3:::${var.bucket_name}/*"
        ]
      },
      {
        Action   = "sns:Publish"
        Effect   = "Allow"
        Resource = aws_sns_topic.evidence_identity_response.arn
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "attach_lambda_s3_sns_policy" {
  role       = aws_iam_role.adsk_lambda_s3_evidence_identity.name
  policy_arn = aws_iam_policy.lambda_s3_sns_policy.arn
}

##  NULL resource to delete the bucket objects and bucket as well using a shell script
##  This null resource trigger only when tf destroy command issued
##  Null Resource to Empty and Delete the Bucket (only on destroy)

resource "null_resource" "empty_and_delete_s3_bucket" {
  # Set count to 0 during apply, 1 during destroy
  count = var.is_destroy ? 1 : 0
  provisioner "local-exec" {
    command = "bash lambda/empty_s3bucket.sh"
  }
  lifecycle {
    prevent_destroy = true # Prevent accidental deletion during apply
  }
  depends_on = [aws_s3_bucket.evidence_bucket]
}


