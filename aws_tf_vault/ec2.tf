resource "aws_instance" "vault-demo" {
  ami                    = "ami-0614680123427b75e"
  instance_type          = "t2.micro"
  key_name               = "mac"
  vpc_security_group_ids = ["sg-0fb1052b659369aa8"]
  tags = {
    Name  = "Vault_demo_machine"
    Owner = "Terraform with Vault CLI"
  }
}
