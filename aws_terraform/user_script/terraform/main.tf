data "aws_ami" "amazon-linux" {
  most_recent = true

  filter {
    name   = "name"
    values = ["amzn2-ami-kernel-5.10-hvm-*-x86_64-gp2"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_instance" "lab_machine" {
  ami                    = data.aws_ami.amazon-linux.id
  instance_type          = var.vmspec
  count                  = 2
  vpc_security_group_ids = [var.sgp]
  key_name               = var.sshkey
  tags                   = merge(var.tagging, { Name = "Apache-server-${count.index + 1}" })
}