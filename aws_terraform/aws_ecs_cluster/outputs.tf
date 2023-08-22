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

output "vm_publicip" {
  value = [for vm in aws_instance.vm : vm.public_ip]
}
output "vm_privateip" {
  value = [for vm in aws_instance.vm : vm.private_ip]
}
output "vm_arn" {
  value = [for vm in aws_instance.vm : vm.arn]
}
