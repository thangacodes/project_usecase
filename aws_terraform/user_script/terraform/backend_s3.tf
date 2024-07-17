terraform {
  backend "s3" {
    bucket = "gitops-demo-bucket-tf"
    key    = "apache/statefile"
    region = "ap-south-1"
  }
}