resource "aws_instance" "s3_lock_test" {
  ami                    = var.amiid
  instance_type          = var.vmspec
  vpc_security_group_ids = [var.sgp]
  key_name               = var.sshkey
  tags                   = var.tagging
}

terraform {
  backend "s3" {
    bucket       = "gitops-demo-bucket-tf"
    key          = "testing/tfstate/terraform.tfstate"
    region       = "ap-south-1"
    encrypt      = true
    use_lockfile = true
  }
}
