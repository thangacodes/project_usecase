module "dev" {
  source              = "./dev/"
  region              = "us-east-1"
  vpc_cidr            = "10.124.0.0/16"
  private_subnetcidrs = ["10.124.1.0/24", "10.124.2.0/24", "10.124.3.0/24", "10.124.4.0/24"]
  public_subnetcidrs  = ["10.124.10.0/24", "10.124.11.0/24", "10.124.12.0/24", "10.124.13.0/24"]
  instance_type       = "t3.small"
  key_name            = "SSHKEY"
  tagging = {
    "Environment"  = "Development",
    "CostCenter"   = "1005100",
    "Owner"        = "Thangadurai@example.com",
    "CreationDate" = "22-03-2024",
    "Project"      = "BlackBox App development"
  }
}
