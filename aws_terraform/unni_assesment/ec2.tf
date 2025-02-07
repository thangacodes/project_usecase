## Data block to fetch dynamic image on "ap-south-1" region 

data "aws_ami" "mumbai-ubuntu-ami" {
  most_recent = true
  owners      = ["099720109477"]
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-*"]
  }
}

resource "aws_instance" "labvm" {
  ami                    = data.aws_ami.mumbai-ubuntu-ami.id
  instance_type          = var.vmspec
  key_name               = var.sshkey
  subnet_id              = aws_subnet.public[0].id
  vpc_security_group_ids = [var.ec2_sgp]
  tags = {
    Name = "Lab-Bastion-VM"
  }
}