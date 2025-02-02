region           = "ap-south-1"
aws_profile_name = "vault_admin"
amiid            = "ami-05fa46471b02db0ce"
vmspec           = "t2.micro"
sgp              = "sg-0fb1052b659369aa8"
sshkey           = "mac"
tagging = {
  Name         = "backend_s3_lock_testing"
  Environment  = "Development"
  CreationDate = "2/2/2025"
  Owner        = "td@try-devops.xyz"
  Tf_version   = "v1.10.5"
}
