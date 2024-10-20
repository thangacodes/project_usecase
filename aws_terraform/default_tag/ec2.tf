resource "aws_instance" "tdtag" {
  ami                    = "ami-04a37924ffe27da53"
  instance_type          = "t2.micro"
  key_name               = "mac"
  vpc_security_group_ids = ["sg-0fb1052b659369aa8"]
  tags = {
    Name = "ec2-box"
  }
}
