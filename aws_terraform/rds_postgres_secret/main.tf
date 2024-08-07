resource "aws_vpc" "db_vpc" {
  cidr_block = var.vpcrange
  tags       = merge(var.tagging, { Name = "Database-VPC" })
}

resource "aws_internet_gateway" "db_igw" {
  vpc_id = aws_vpc.db_vpc.id
  tags   = merge(var.tagging, { Name = "Database-IGW" })
}

resource "aws_subnet" "public" {
  vpc_id            = aws_vpc.db_vpc.id
  cidr_block        = var.pub_cidr
  availability_zone = "ap-south-1c"
  tags              = merge(var.tagging, { Name = "Public-subnet-1" })
}

resource "aws_subnet" "public2" {
  vpc_id            = aws_vpc.db_vpc.id
  cidr_block        = var.pub_cidr2
  availability_zone = "ap-south-1a"
  tags              = merge(var.tagging, { Name = "Public-subnet-2" })
}

resource "aws_subnet" "private" {
  vpc_id     = aws_vpc.db_vpc.id
  cidr_block = var.priv_cidr
  tags       = merge(var.tagging, { Name = "Private-subnet-1" })
}

resource "aws_route_table" "pubrt" {
  vpc_id = aws_vpc.db_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.db_igw.id
  }
  tags = merge(var.tagging, { Name = "Public-RouteTable" })
}

resource "aws_route_table" "pvtrt" {
  vpc_id = aws_vpc.db_vpc.id
  tags   = merge(var.tagging, { Name = "Private-RouteTable" })
}

resource "aws_route_table_association" "pubassoc" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.pubrt.id
}

resource "aws_route_table_association" "pubassoc2" {
  subnet_id      = aws_subnet.public2.id
  route_table_id = aws_route_table.pubrt.id
}
resource "aws_route_table_association" "pvtassoc" {
  subnet_id      = aws_subnet.private.id
  route_table_id = aws_route_table.pvtrt.id
}

### Secrets Manager
resource "aws_secretsmanager_secret" "dbpass" {
  name = "prd/postgres/password"
  tags = merge(var.tagging, { Name = "PostgresDBPassword" })
}

resource "aws_secretsmanager_secret_version" "dbpass_version" {
  secret_id     = aws_secretsmanager_secret.dbpass.id
  secret_string = var.db_password
}

# Define the DB Subnet Group
resource "aws_db_subnet_group" "dbsub" {
  name       = "db-subnet-group"
  subnet_ids = [aws_subnet.public.id, aws_subnet.public2.id] # Reference the subnet IDs here

  tags = {
    Name = "db-subnet-group"
  }
}

### RDS instance
resource "aws_db_instance" "postdb" {
  allocated_storage      = 10
  db_name                = "india"
  engine                 = "postgres"
  engine_version         = "16.3"
  instance_class         = "db.t3.micro"
  username               = var.db_username
  password               = var.db_password
  parameter_group_name   = "default.postgres16"
  db_subnet_group_name   = aws_db_subnet_group.dbsub.name
  skip_final_snapshot    = true
  vpc_security_group_ids = [aws_security_group.dbsgp.id]
}

## Database Security group
resource "aws_security_group" "dbsgp" {
  name        = "postgres-db-sgp"
  description = "SecurityGroup for postgres db"

  vpc_id = aws_vpc.db_vpc.id

  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.tagging, { Name = "Postgres-DB-SGP" })
}
