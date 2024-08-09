resource "aws_lb" "test" {
  name               = "LB"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.SG.id]
  subnets            = [aws_subnet.pubsub1.id, aws_subnet.pubsub2.id]
  tags               = merge(var.tagging, { Name = "ECS_APP_LB" })

}

resource "aws_lb_listener" "Listener" {
  load_balancer_arn = aws_lb.test.arn
  port              = 80
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.TG.id
  }
}
