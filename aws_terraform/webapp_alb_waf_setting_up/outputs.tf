output "PublicIP" {
  value = aws_instance.drift_detection.*.public_ip
}
output "PrivateIP" {
  value = aws_instance.drift_detection.*.private_ip
}
output "Tag_find" {
  value = aws_instance.drift_detection.*.tags_all
}
# output "Instance_EndPoint" {
#   value = "http://${aws_instance.drift_detection.*.public_ip}:80/"
# }
output "Alb_endpoint" {
  value = "http://${aws_alb.waf-test-alb.dns_name}"
}
output "Target_id" {
  value = aws_lb_target_group.waf-app.id
}
