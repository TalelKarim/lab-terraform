provider "aws" {
  region = "us-east-1" # Specify your desired AWS region
}

resource "aws_security_group" "rdssg" {
  name   = "rdssg"
  vpc_id = "vpc-0f2534cdfaf552861"

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

  # Other optional configurations for cost optimization
  backup_retention_period    = 7
  multi_az                   = false
  publicly_accessible        = false
  skip_final_snapshot        = true
  auto_minor_version_upgrade = true
}
