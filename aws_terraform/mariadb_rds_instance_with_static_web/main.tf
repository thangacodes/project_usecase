### Simple EC2 creation
resource "aws_instance" "mac-vm" {
  instance_type          = var.instance_type
  ami                    = var.ami
  key_name               = var.key_name
  vpc_security_group_ids = [var.sgp]
  user_data              = file("userdata.sh")
  tags                   = merge(var.tagging, { Name = "Mac-VM" })
}

resource "aws_kms_key" "labcheck" {
  description             = "KMS key for RDS Instance"
  deletion_window_in_days = 2
  is_enabled              = true
  enable_key_rotation     = true
  tags                    = merge(var.tagging, { Name = "RDS_KMS_KEY" })
}

resource "random_password" "pass" {
  special          = true
  length           = 16
  override_special = "_!%"
}

resource "aws_secretsmanager_secret" "rds-secret" {
  name                    = "rds_admin"
  kms_key_id              = aws_kms_key.labcheck.id
  description             = "RDS admin password"
  recovery_window_in_days = 5
  tags                    = merge(var.tagging, { Name = "RDS_SECRET_MANAGER" })
}

resource "aws_secretsmanager_secret_version" "secret" {
  secret_id     = aws_secretsmanager_secret.rds-secret.id
  secret_string = random_password.pass.result
}

data "aws_secretsmanager_secret" "fetching" {
  name       = "rds_admin"
  depends_on = [aws_secretsmanager_secret.rds-secret]
}

data "aws_secretsmanager_secret_version" "secret" {
  secret_id = data.aws_secretsmanager_secret.fetching.id
}

resource "aws_db_instance" "mysqldb" {
  storage_type         = "gp2"
  allocated_storage    = 10
  engine               = "mariadb"
  engine_version       = "10.11.8"
  instance_class       = "db.t3.micro"
  db_name              = "technology"
  username             = ""
  password             = data.aws_secretsmanager_secret_version.secret.secret_string
  parameter_group_name = "default.mariadb10.11"
  skip_final_snapshot  = true
  publicly_accessible  = true
  multi_az             = false
  storage_encrypted    = true
  tags                 = merge(var.tagging, { Name = "Maria-database" })
}

#### AWSCLI command:
## aws secretsmanager get-secret-value --secret-id rds_admin    // To retrive the password from secretmanager service via cli
