resource "aws_secretsmanager_secret" "secret" {
  name = "rdscred"
  tags = merge(local.tagging, { Name = "RDS_CRED" })
}

resource "aws_secretsmanager_secret_version" "example" {
  secret_id     = aws_secretsmanager_secret.secret.id
  secret_string = jsonencode(local.default)
}

data "aws_secretsmanager_secret_version" "dbsecret" {
  secret_id = aws_secretsmanager_secret.secret.id
}

### To test the connectivity
resource "aws_instance" "sqlclient" {
  ami                    = local.vm.ami_id
  instance_type          = local.vm.instance_type
  vpc_security_group_ids = [local.vm.sgp]
  key_name               = local.vm.key_name
  user_data              = file("mysql_client_install.sh")
  tags                   = merge(local.tagging, { Name = "MySQL-Client-Machine" })
}

### fetching public ip of the local machine like laptop. Not the EC2 instance
data "http" "mypubip" {
  url = "http://ipv4.icanhazip.com"
}

### db security group creation
resource "aws_security_group" "dbsgp" {
  name        = "mysql_db_sgp"
  description = "Security_group for db instance"
  vpc_id      = "vpc-71c2281a"

  ingress {
    from_port   = "3306"
    to_port     = "3306"
    protocol    = "tcp"
    cidr_blocks = ["${chomp(data.http.mypubip.body)}/32"]
  }
  ingress {
    from_port   = "22"
    to_port     = "22"
    protocol    = "tcp"
    cidr_blocks = data.aws_instance.sqlclient.ip / 32
  }
  tags = merge(local.tagging, { Name = "DB_security_group" })
}

### MySQL DB instance creation
resource "aws_db_instance" "db" {
  allocated_storage      = 10
  db_name                = "mydb"
  engine                 = "mysql"
  engine_version         = "5.7"
  instance_class         = "db.t3.micro"
  parameter_group_name   = "default.mysql5.7"
  vpc_security_group_ids = [aws_security_group.dbsgp.id]
  skip_final_snapshot    = true
  username               = local.default.username
  password               = local.default.password
  tags                   = merge(local.tagging, { Name = "Cloud_fun_MySQLDB" })
}

