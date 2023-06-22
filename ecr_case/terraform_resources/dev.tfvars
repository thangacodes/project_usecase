docker_image_tag = "v3"
ecr_repo_url     = "282526987315.dkr.ecr.ap-south-1.amazonaws.com"
ecr_repo_name    = "terraform-app"

ingress_rules = [{
  protocol         = "tcp"
  from_port        = 80
  to_port          = 80
  cidr_blocks      = ["0.0.0.0/0"]
  description      = "Inbound ECR Security Group"
  ipv6_cidr_blocks = []
  prefix_list_ids  = []
  security_groups  = []
  self             = false

  },
  {
    protocol         = -1
    from_port        = 0
    to_port          = 0
    cidr_blocks      = ["0.0.0.0/0"]
    description      = "Inbound ECR Security Group"
    ipv6_cidr_blocks = []
    prefix_list_ids  = []
    security_groups  = []
    self             = false
  },
  {
    protocol         = "tcp"
    from_port        = 22
    to_port          = 22
    cidr_blocks      = ["0.0.0.0/0"]
    description      = "Inbound ECR Security Group"
    ipv6_cidr_blocks = []
    prefix_list_ids  = []
    security_groups  = []
    self             = false
  }
]
