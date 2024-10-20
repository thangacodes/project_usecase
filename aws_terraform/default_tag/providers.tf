provider "aws" {
  region     = var.region
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key

  default_tags {
    tags = {
      CostCenter   = "100232432"
      Environment  = "Development"
      ProjectName  = "BlackDuck-App"
      Owner        = "Thangadurai.murugan@example.com"
      Creationdate = "20/10/2024"
    }
  }
}
