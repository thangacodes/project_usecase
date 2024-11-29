# Data source to fetch the latest Amazon Linux 3 AMI against MUMBAI region (ap-south-1)
data "aws_ami" "amazon_linux_3" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = ["al2023-ami-2023.6.20241121.0-kernel-6.1-x86_64"]
  }
}

# Create an MSK cluster using default VPC
data "aws_vpc" "default" {
  default = true
}

# Fetch public subnets in the default VPC
data "aws_subnets" "def_public_subnets" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}
resource "aws_msk_cluster" "demo" {
  cluster_name           = var.cluster_name
  kafka_version          = var.kafka_version
  number_of_broker_nodes = 2

  broker_node_group_info {
    instance_type   = var.kafka_ins_type
    client_subnets  = slice(data.aws_subnets.def_public_subnets.ids, 0, 2)
    security_groups = var.security_groups
  }
}

# IAM policy for MSK access
resource "aws_iam_policy" "msk_policy" {
  name        = "MSKFullAccessPolicy"
  description = "Policy granting full access to MSK clusters"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action   = "kafka:DescribeCluster"
        Effect   = "Allow"
        Resource = "*"
      },
      {
        Action   = "kafka:CreateTopic"
        Effect   = "Allow"
        Resource = "*"
      },
      {
        Action   = "kafka:DeleteTopic"
        Effect   = "Allow"
        Resource = "*"
      },
      {
        Action   = "kafka:AlterTopic"
        Effect   = "Allow"
        Resource = "*"
      },
      {
        Action   = "kafka:ListClusters"
        Effect   = "Allow"
        Resource = "*"
      },
      {
        Action   = "kafka:ListTopics"
        Effect   = "Allow"
        Resource = "*"
      },
      {
        Action   = "kafka:WriteData"
        Effect   = "Allow"
        Resource = "*"
      },
      {
        Action   = "kafka:ReadData"
        Effect   = "Allow"
        Resource = "*"
      }
    ]
  })
}

# IAM role for EC2 instance
resource "aws_iam_role" "ec2_role" {
  name = "ec2tomskrole"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
        Effect = "Allow"
      }
    ]
  })
}

# Attach the MSK policy to the IAM role
resource "aws_iam_role_policy_attachment" "msk_policy_attachment" {
  policy_arn = aws_iam_policy.msk_policy.arn
  role       = aws_iam_role.ec2_role.name
}

# IAM instance profile to associate with EC2
resource "aws_iam_instance_profile" "ec2_instance_profile" {
  name = "ec2tomskprofile"
  role = aws_iam_role.ec2_role.name
}

# Launch the EC2 instance
resource "aws_instance" "kafka_instance" {
  ami                    = data.aws_ami.amazon_linux_3.id
  instance_type          = var.vmspec  # Choose your instance type
  key_name               = var.keypair # Replace with your SSH key
  vpc_security_group_ids = [var.sgp]
  iam_instance_profile   = aws_iam_instance_profile.ec2_instance_profile.name
  user_data              = file("bootstrap.sh")
  tags                   = var.tagging
}
