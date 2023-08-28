resource "tls_private_key" "terrafrom_generated_private_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "generated_key" {
  key_name   = "jenkins"
  public_key = tls_private_key.terrafrom_generated_private_key.public_key_openssh

  provisioner "local-exec" {
    command = <<-EOT
       echo '${tls_private_key.terrafrom_generated_private_key.private_key_pem}' > jenkins.pem
       chmod 400 jenkins.pem
     EOT
  }
}
