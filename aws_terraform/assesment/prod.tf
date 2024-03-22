module "prod" {
  source              = "./prd/"
  region              = "us-east-1"
  vpc_cidr            = "10.224.0.0/16"
  private_subnetcidrs = ["10.224.1.0/24", "10.224.2.0/24", "10.224.3.0/24", "10.224.4.0/24"]
  public_subnetcidrs  = ["10.224.10.0/24", "10.224.11.0/24", "10.224.12.0/24", "10.224.13.0/24"]
  instance_type       = "t3.small"
  key_name            = "SSHKEY"
  tagging = {
    "Environment"  = "Development",
    "CostCenter"   = "1005100",
    "Owner"        = "Thangadurai.murugan@example.com",
    "CreationDate" = "22-03-2024",
    "Project"      = "BlackBox App development"
  }
}
