## Creating Security Group for Application Load balancer
resource "aws_security_group" "alb_sg" {
  name        = "lab_app_sgp"
  description = "Allow HTTP and HTTPS traffic to the ALB"
  vpc_id      = aws_vpc.lab.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "LabAppSgp"
  }
}
## Create Application Load Balancer 
resource "aws_lb" "lab_lb" {
  name                             = "LABAPPALB"
  internal                         = false
  load_balancer_type               = "application"
  security_groups                  = [aws_security_group.alb_sg.id]
  subnets                          = [aws_subnet.private[0].id, aws_subnet.private[1].id]
  enable_deletion_protection       = false
  enable_cross_zone_load_balancing = true

  tags = {
    Name = "LABAPPALB"
  }
}

## Creating ALB target Group

resource "aws_lb_target_group" "app_target_group" {
  name        = "app-target-group"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = aws_vpc.lab.id
  target_type = "instance"

  health_check {
    path                = "/"
    interval            = 20
    timeout             = 5
    healthy_threshold   = 3
    unhealthy_threshold = 3
    protocol            = "HTTP"
  }
  tags = {
    Name = "LAB_ALB_TGP"
  }
}

# Creating a Listener for the ALB
resource "aws_lb_listener" "http_listener" {
  load_balancer_arn = aws_lb.lab_lb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app_target_group.arn
  }
  tags = {
    Name = "LAB_ALB_LISTENER"
  }
}
