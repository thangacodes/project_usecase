resource "aws_instance" "jenkins" {
  ami                    = local.ami
  instance_type          = local.vm_size
  key_name               = aws_key_pair.generated_key.id
  vpc_security_group_ids = local.sgpid
  subnet_id              = aws_subnet.public.id
  user_data              = file("jenkins.sh")
  tags                   = merge(var.identity, { Name = "Jenkins-Server" })
}
