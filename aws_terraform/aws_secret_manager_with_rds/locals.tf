locals {
  default = {
    username  = "root"
    password  = "secret"
    sensitive = true
  }
}

### Tagging section for the resources
locals {
  tagging = {
    Environment  = "Sandbox"
    Owner        = "Thangadurai.murugan@example.com"
    CreationDate = "21/09/2023"
    CostCentre   = "1000434"
    Application  = "Cloud-fun app"
    TF_version   = "1.5.7"
    AWS_version  = "5.17.0"
  }
}

#### Instance details feeding via local variables
locals {
  vm = {
    ami_id        = "ami-067c21fb1979f0b27"
    instance_type = "t2.micro"
    key_name      = "admin"
    sgp           = "sg-0fb1052b659369aa8"
  }
}

## Note: We shouldn't hard code the password in the scripts. Instead, first create secrets in secret_manager and then call it in the tf scripts.
