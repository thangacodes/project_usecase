## This demo is mainly to show you what is the difference between count vs for_each in terraform.

## Count property:
/*
resource "aws_ecs_cluster" "cluster_1" {
  name  = element(local.cluster_names, count.index)
  count = length(local.cluster_names)
  tags = {
    Environment  = local.env
    CreationDate = local.date
    Owner        = local.owner
    CostCenter   = local.cost
  }
}
*/

## For_each property:
resource "aws_ecs_cluster" "cluster" {
  for_each = toset(local.cluster_names)
  name     = each.key
  tags = {
    Environment  = local.env
    CreationDate = local.date
    Owner        = local.owner
    CostCenter   = local.cost
  }
}

## Takeaway here is that, 
# for_each is lot more powerful than count property in terraform.
# If you have 4 cluster in ECS, some scenario you wants to remove a particular cluster. In this for_each will work as we expected.
# It removes that particular cluster.


