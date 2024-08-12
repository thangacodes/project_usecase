region  = "ap-south-1"
vpccidr = "140.0.0.0/16"
tagging = {
  Environment  = "Sandbox"
  CreationDate = "12/08/2024"
  Project      = "Cloudbird.fun"
  Owner        = "Thangadurai.murugan@cloudbird.fun"
}
pubsub = [
  {
    name = "public-subnet-1"
    cidr = "140.0.1.0/24"
  },
  {
    name = "public-subnet-2",
    cidr = "140.0.2.0/24"
  },
  {
    name = "public-subnet-3"
    cidr = "140.0.3.0/24"
  }
]
pvtsub = [
  {
    name = "private-subnet-1"
    cidr = "140.0.4.0/24"
  },
  {
    name = "private-subnet-2",
    cidr = "140.0.5.0/24"
  },
  {
    name = "private-subnet-3"
    cidr = "140.0.6.0/24"
  }
]
