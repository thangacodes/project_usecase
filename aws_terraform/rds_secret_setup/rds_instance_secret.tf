resource "aws_db_instance" "appdb" {
  identifier          = "rds-db-instance"
  allocated_storage   = 20
  storage_type        = "gp2"
  engine              = "mysql"
  engine_version      = 5.7
  instance_class      = var.instance_class
  username            = var.db_username
  password            = data.aws_secretsmanager_secret_version.password.secret_string
  skip_final_snapshot = true
  tags                = merge(var.tagging, { Name = "BackendAppDatabase" })
}

data "aws_secretsmanager_secret" "secrets" {
  name = var.password
}

data "aws_secretsmanager_secret_version" "password" {
  secret_id = data.aws_secretsmanager_secret.secrets.id
}

output "secret_arn" {
  value = data.aws_secretsmanager_secret.secrets.arn
}
output "secret_value" {
  sensitive = true
  value     = data.aws_secretsmanager_secret_version.password.secret_string
}
