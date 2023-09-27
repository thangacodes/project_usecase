resource "tls_private_key" "ssh-key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "generated_key" {
  key_name   = "sshkey"
  public_key = tls_private_key.ssh-key.public_key_openssh

  provisioner "local-exec" {
    command = <<-EOT
         echo '${tls_private_key.ssh-key.private_key_pem}' >> ../ansible/sshkey.pem
         chmod 400 sshkey.pem
      EOT
  }
}
resource "local_file" "local_key_pair" {
  filename        = ("ansible/sshkey.pem")
  file_permission = "0600"
  content         = tls_private_key.ssh-key.private_key_pem
}

############### Security Group Creation #####################
resource "aws_security_group" "public" {
  name        = "Jenkins-public-sg"
  description = "Public internet access"
  vpc_id      = aws_vpc.lab.id
  tags        = merge(var.identity, { Name = "Jenkins-public-sg" })
}

resource "aws_security_group_rule" "public_out" {
  type        = "egress"
  from_port   = 0
  to_port     = 0
  protocol    = "-1"
  cidr_blocks = ["0.0.0.0/0"]

  security_group_id = aws_security_group.public.id
}

resource "aws_security_group_rule" "public_in_ssh" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.public.id
}

resource "aws_security_group_rule" "public_in_http" {
  type              = "ingress"
  from_port         = 8080
  to_port           = 8080
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.public.id
}
