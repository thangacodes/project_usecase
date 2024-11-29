output "bootstrap-server" {
  value = aws_msk_cluster.demo.bootstrap_brokers
}

output "bootstrap-server-arn" {
  value = aws_msk_cluster.demo.arn
}

output "vmpublicip" {
  value = "Public IP: ${aws_instance.kafka_instance.public_ip}"
}

output "vmkeyname" {
  value = aws_instance.kafka_instance.key_name
}
