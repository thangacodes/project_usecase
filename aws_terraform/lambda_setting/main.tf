provider "aws" {
  region  = var.region
  profile = var.profile_name
}

# 1. Create IAM role with Lambda invocation permissions
resource "aws_iam_role" "lambda_invocation_role" {
  name = "adsk-lambda-invoke-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      },
    ]
  })
}

# 2. Attach Inline Policy for Full S3 Permissions
resource "aws_iam_policy" "s3_read_policy" {
  name        = "LambdaS3ReadPolicy"
  description = "Allows Lambda to read objects from a specific S3 bucket"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = "s3:GetObject"
        Resource = "arn:aws:s3:::${var.bucket_name}/json_data.json"
      },
    ]
  })
}

# Query the existing S3 bucket
data "aws_s3_bucket" "existing_bucket" {
  bucket = var.bucket_name # The existing bucket name
}

# Define the S3 Bucket Policy and attach it to the existing bucket
resource "aws_s3_bucket_policy" "lambda_s3_bucket_policy" {
  bucket = data.aws_s3_bucket.existing_bucket.id # Using the queried bucket's ID

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          AWS = "arn:aws:iam::${ACCOUNT ID}:role/adsk-lambda-invoke-role" # The Lambda IAM Role ARN
        }
        Action   = "s3:GetObject"
        Resource = "arn:aws:s3:::${var.bucket_name}/json_data.json" # The specific S3 object
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "s3_read_policy" {
  role       = aws_iam_role.lambda_invocation_role.name
  policy_arn = aws_iam_policy.s3_read_policy.arn
}

# Attach a basic Lambda execution policy to allow CloudWatch logs
resource "aws_iam_role_policy_attachment" "attach_lambda_execution_policy" {
  role       = aws_iam_role.lambda_invocation_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

# 3. Create the Lambda function
resource "aws_lambda_function" "first_lambda_function" {
  function_name = var.function_name

  # Path to your Python deployment package (ZIP file)
  filename         = "lambda.zip"
  source_code_hash = filebase64sha256("lambda.zip")
  handler          = "lambda.lambda_handler" # Python file and function
  runtime          = "python3.10"            # Use the desired runtime
  role             = aws_iam_role.lambda_invocation_role.arn
}

# 4. Testing the Lambda function using aws_lambda_invocation data source
data "aws_lambda_invocation" "test_lambda" {
  function_name = aws_lambda_function.first_lambda_function.function_name
  # You can pass a test event here. For simplicity, we are passing an empty event
  input = jsonencode({
    first_event = "terraform"
    action      = "update_profile"
  })
  qualifier = "$LATEST" # Use the latest version
}
