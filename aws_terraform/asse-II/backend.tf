terraform {
  backend "s3" {
    bucket         = "gitops-demo-bucket-tf"
    key            = "gitops-demo-bucket-tf/state/"
    region         = "ap-south-1"
    dynamodb_table = "backend"
  }
}