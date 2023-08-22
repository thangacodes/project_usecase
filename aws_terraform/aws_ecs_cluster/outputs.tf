output "ecs_cluster_name_finding" {
  value = [for cluster in aws_ecs_cluster.cluster : cluster.name]
}
output "ecs_cluster_id_finding" {
  value = [for cluster in aws_ecs_cluster.cluster : cluster.id]
}
output "ecs_cluster_tags_finding" {
  value = [for cluster in aws_ecs_cluster.cluster : cluster.tags]
}
output "ecs_cluster_arn_finding" {
  value = [for cluster in aws_ecs_cluster.cluster : cluster.arn]
}
