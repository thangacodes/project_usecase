vpccidr              = "192.168.0.0/16"
public_subnet        = ["192.168.151.0/24", "192.168.152.0/24"]
private_subnet       = ["192.168.153.0/24", "192.168.154.0/24"]
ap_availability_zone = ["ap-south-1a", "ap-south-1b"]
tagging = {
  Environment      = "Development"
  Owner            = "Thangadurai.murugan@example.com"
  CreationDate     = "07/15/2024"
  TerraformVersion = "v1.9.1"
}
