
resource "aws_db_subnet_group" "my_database_subnet_group" {
  name        = "my-database-subnet-group"
  description = "My RDS database subnet group"
  subnet_ids  = var.subnet_ids # List of subnet IDs in your VPC
}

resource "aws_security_group" "rdssg" {
  name   = "rdssg"
  vpc_id = var.vpc_id

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]

  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]

  }
}

resource "aws_db_instance" "my_database" {
  identifier        = "my-mysql-database"
  engine            = var.engine
  instance_class    = var.instance_class    # Choose an instance type suitable for your needs
  allocated_storage = var.allocated_storage # Size of the database storage in gibibytes
  storage_type      = var.storage_type      # General Purpose SSD

  vpc_security_group_ids = [aws_security_group.rdssg.id]
  db_name                = var.db_name     # Your desired database name
  username               = var.db_username # Your desired database username
  password               = var.db_password # Your desired database password
  db_subnet_group_name   = aws_db_subnet_group.my_database_subnet_group.name


  # Other optional configurations for cost optimization
  backup_retention_period    = 7
  multi_az                   = false
  publicly_accessible        = true
  skip_final_snapshot        = true
  auto_minor_version_upgrade = true
}
