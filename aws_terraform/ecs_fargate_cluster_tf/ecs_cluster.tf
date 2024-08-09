locals {
  cluster_name = "my_ecs"
}

resource "aws_ecs_cluster" "labcluster" {
  name = local.cluster_name
  tags = merge(var.tagging, { Name = "${local.cluster_name}-FARGATE-CLUSTER" })
}
