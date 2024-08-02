vpc_range = "192.168.0.0/16"
common_tag = {
  Environment  = "Development"
  Costcenter   = "1293200"
  CreationDate = "01/08/2024"
  Owner        = "Thangadurai.murugan@cloudbird.fun"
  Project      = "Eightstar"
}
pvtcidr = ["192.168.1.0/24", "192.168.2.0/24", "192.168.3.0/24"]
pubcidr = ["192.168.4.0/24", "192.168.5.0/24"]
region  = "ap-south-1"
vmspec  = "t2.micro"
