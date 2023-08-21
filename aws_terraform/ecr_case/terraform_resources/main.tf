resource "null_resource" "push_docker" {
  provisioner "local-exec" {
    command = "sh scripts/push-docker.sh ${var.docker_image_tag} ${var.ecr_repo_url} ${var.ecr_repo_name}"
  }
  triggers = {
    image_tag = var.docker_image_tag
  }
}

### Security group creation
resource "aws_security_group" "ecr-sgp" {
  depends_on  = [null_resource.push_docker]
  description = "ecr security group"
  vpc_id      = "vpc-71c2281a"
  ingress     = var.ingress_rules

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
  tags = {
    Name = "ecr-sgp"
  }
}

resource "aws_instance" "ecr_ec2" {
  depends_on                  = [null_resource.push_docker]
  count                       = var.number_of_instances
  ami                         = "ami-0607784b46cbe5816"
  instance_type               = "t2.micro"
  key_name                    = "admin"
  subnet_id                   = "subnet-e9190a81"
  associate_public_ip_address = true
  availability_zone           = "ap-south-1a"
  vpc_security_group_ids      = [aws_security_group.ecr-sgp.id]
  root_block_device {
    volume_size           = 10
    volume_type           = "gp2"
    delete_on_termination = true
  }
  user_data = file("scripts/install-pre-requisites.sh")


  iam_instance_profile = "ec2-admin-role"
  tags = {
    "Name" = "ecr-ec2-vm"
  }

}

resource "time_sleep" "wait_60_seconds" {
  depends_on      = [aws_instance.ecr_ec2]
  create_duration = "90s"
}

resource "null_resource" "pull_docker" {
  count      = var.number_of_instances
  depends_on = [time_sleep.wait_60_seconds]

  connection {
    type        = "ssh"
    host        = aws_instance.ecr_ec2[count.index].public_ip
    user        = "ec2-user"
    password    = ""
    private_key = file("private_key/admin.pem")
  }

  provisioner "remote-exec" {
    inline = [
      "docker kill $(docker ps -qa)",
      "docker image rm $(docker image ls -q) --force",
      "aws ecr get-login-password --region ap-south-1 | docker login --username AWS --password-stdin ${var.ecr_repo_url}",
      "docker pull ${var.ecr_repo_url}/${var.ecr_repo_name}:${var.docker_image_tag}",
      "docker run -d -p 80:80 ${var.ecr_repo_url}/${var.ecr_repo_name}:${var.docker_image_tag}"
    ]
  }
  triggers = {
    image_tag = var.docker_image_tag
  }
}




resource "aws_lb" "LoadBalancer" {
  name               = "ecr-alb"
  internal           = false
  load_balancer_type = "application"
  subnets = [
    "subnet-e9190a81",
    "subnet-d866eda3"
  ]
  security_groups = [aws_security_group.ecr-sgp.id]
  ip_address_type = "ipv4"

}

resource "aws_lb_target_group" "targetGroup" {
  health_check {
    interval            = 30
    path                = "/"
    port                = "traffic-port"
    protocol            = "HTTP"
    timeout             = 5
    unhealthy_threshold = 2
    healthy_threshold   = 5
    matcher             = "200"
  }
  port        = 80
  protocol    = "HTTP"
  target_type = "instance"
  vpc_id      = "vpc-71c2281a"
  name        = "ecr-tg"
}

resource "aws_lb_target_group_attachment" "test" {
  count            = var.number_of_instances
  target_group_arn = aws_lb_target_group.targetGroup.arn
  target_id        = aws_instance.ecr_ec2[count.index].id
  port             = 80
}

resource "aws_lb_listener" "front_end" {
  load_balancer_arn = aws_lb.LoadBalancer.arn
  port              = "80"
  protocol          = "HTTP"
  # ssl_policy        = "ELBSecurityPolicy-2016-08"
  # certificate_arn   = "arn:aws:iam::187416307283:server-certificate/test_cert_rab3wuqwgja25ct3n4jdj2tzu4"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.targetGroup.arn
  }
}
