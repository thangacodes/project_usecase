provider "aws" {
  region  = "ap-south-1"
  profile = "vault-dev"
}

provider "vault" {
  address = "http://127.0.0.1:8200"
}
