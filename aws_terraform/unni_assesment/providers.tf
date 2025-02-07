provider "aws" {
  region  = var.region
  profile = var.profile
  default_tags {
    tags = {
      CostCenter   = "1000000"
      Environment  = "Development"
      ProjectName  = "try-devops"
      Owner        = "author@example.com"
      Creationdate = "6/02/2024"
      TF_Version   = "v1.10.5"
    }
  }
}
