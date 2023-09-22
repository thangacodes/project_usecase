output "vm_pubip" {
  value = aws_instance.sqlclient.public_ip
}
output "vm_pvtip" {
  value = aws_instance.sqlclient.private_ip
}
output "dbendpoint" {
  value = aws_db_instance.db.endpoint
}
output "dbarn" {
  value = aws_db_instance.db.arn
}
