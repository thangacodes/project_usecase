## VPC Creation #######
resource "aws_vpc" "demo" {
  cidr_block = var.cidr_block
  tags       = merge(var.tags, { Name = "WAF-TEST-VPC" })
}

### Internet Gateway Creation
resource "aws_internet_gateway" "demo" {
  vpc_id = aws_vpc.demo.id
  tags   = merge(var.tags, { Name = "WAF-IGW" })
}

### Public Subnet creation
resource "aws_subnet" "public" {
  vpc_id            = aws_vpc.demo.id
  cidr_block        = var.pubsub_cidr
  availability_zone = "ap-south-1a"
  tags              = merge(var.tags, { Name = "WAF-PUBLIC-SUBNET-1" })
}

resource "aws_subnet" "public2" {
  vpc_id            = aws_vpc.demo.id
  cidr_block        = var.pubsub1_cidr
  availability_zone = "ap-south-1b"
  tags              = merge(var.tags, { Name = "WAF-PUBLIC-SUBNET-1" })
}

### Public Route table creation and routes creation
resource "aws_route_table" "public-rt" {
  vpc_id = aws_vpc.demo.id
  tags   = merge(var.tags, { Name = "WAF-PUBLIC-RT" })
}

### Public subnet association
resource "aws_route_table_association" "public-sub-assoc" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public-rt.id
}
resource "aws_route_table_association" "public-sub2-assoc" {
  subnet_id      = aws_subnet.public2.id
  route_table_id = aws_route_table.public-rt.id
}

resource "aws_route" "igw-route-1" {
  route_table_id         = aws_route_table.public-rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.demo.id
  depends_on = [
    aws_route_table.public-rt
  ]
}
### EC2 Target group creation followed by ALB creations
resource "aws_lb_target_group" "waf-app" {
  name     = "apache-web-waf-test"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.demo.id
  tags     = merge(var.tags, { Name = "apache-web-waf-test" })
}

resource "aws_lb_target_group_attachment" "test" {
  target_group_arn = aws_lb_target_group.waf-app.arn
  target_id        = aws_instance.drift_detection.id
  port             = 80
}

####### ALB creation ##############
resource "aws_alb" "waf-test-alb" {
  name               = "Apache-web-waf-demo"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.waf-sgp.id]
  subnets            = [aws_subnet.public.id, aws_subnet.public2.id]
  tags               = merge(var.tags, { Name = "Apache-Web-WAF-ALB" })
}

resource "aws_lb_listener" "apache" {
  load_balancer_arn = aws_alb.waf-test-alb.arn
  port              = 80
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.waf-app.arn
  }
}

### EC2 Instance creation #################
resource "aws_instance" "drift_detection" {
  ami                         = var.ami_id
  instance_type               = var.vmspec
  key_name                    = var.key
  associate_public_ip_address = true
  subnet_id                   = aws_subnet.public.id
  vpc_security_group_ids      = [aws_security_group.waf-sgp.id]
  user_data                   = file("web_conf.sh")
  tags                        = merge(var.tags, { Name = "WebServer" })
}
### AWS EC2 Security Group creation #######
resource "aws_security_group" "waf-sgp" {
  name        = "WAF-SGP"
  description = "allow ssh from internet and icmp from 15.15.5.0/24"
  vpc_id      = aws_vpc.demo.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = ["15.15.5.0/24", "15.15.6.0/24"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = merge(var.tags, { Name = "WAF-SGP" })
}
