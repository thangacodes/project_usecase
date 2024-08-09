resource "aws_iam_role" "noderole" {
  name = "${local.common_name}-worker"

  assume_role_policy = <<POLICY
    {
       "Version": "2012-10-17",
       "Statement": [ 
         {
           "Effect": "Allow",
           "Principal": {
              "Service": "ec2.amazonaws.com"
           },
           "Action": "sts:AssumeRole"
        }
       ]
    }
POLICY
}

resource "aws_iam_role_policy_attachment" "node_AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.noderole.name
}

resource "aws_iam_role_policy_attachment" "node_AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.noderole.name
}

resource "aws_iam_role_policy_attachment" "node_AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.noderole.name
}

resource "aws_security_group" "node_group_sgp" {
  name        = "${local.common_name}-node-SGP"
  description = "Allow TLS inbound traffic"
  vpc_id      = module.vpc.vpc_id

  ingress {
    description = "Allow nodes to communicate with each other"
    from_port   = 0
    to_port     = 65535
    protocol    = "-1"
  }
  ingress {
    from_port = 1025
    to_port   = 65535
    protocol  = "tcp"
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name                                                 = "${local.common_name}-node-SGP"
    "kubernetes.io/cluster/${local.common_name}-cluster" = "owned"
  }
}

resource "aws_eks_node_group" "main" {
  cluster_name    = local.common_name
  node_group_name = "main"
  node_role_arn   = aws_iam_role.noderole.arn
  subnet_ids      = module.vpc.private_subnets

  scaling_config {
    desired_size = 2
    max_size     = 2
    min_size     = 2
  }
  depends_on = [
    aws_iam_role_policy_attachment.node_AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.node_AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.node_AmazonEC2ContainerRegistryReadOnly,
    aws_eks_cluster.main
  ]
}
