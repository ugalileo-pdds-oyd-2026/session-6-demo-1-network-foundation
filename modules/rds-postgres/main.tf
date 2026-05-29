resource "aws_security_group" "rds" {
  name   = "${var.environment}-rds-sg"
  vpc_id = "vpc-2e760856"
  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["172.31.16.0/20"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
resource "aws_db_subnet_group" "this" {
  name       = "${var.environment}-rds-subnet-group"
  subnet_ids = ["subnet-a88843d0", "subnet-f927d2b3"]
}

resource "aws_db_subnet_group" "new" {
  name       = "${var.environment}-rds-subnet-group-new"
  subnet_ids = var.subnet_ids
}

resource "aws_db_parameter_group" "this" {
  name   = "${var.environment}-postgres16-params"
  family = "postgres16"
}

resource "aws_db_instance" "this" {
  identifier              = "${var.environment}-blog-db"
  engine                  = "postgres"
  engine_version          = "16"
  instance_class          = var.instance_class
  allocated_storage       = var.allocated_storage
  db_name                 = var.db_name
  username                = var.db_username
  password                = var.db_password
  port                    = 5432
  db_subnet_group_name    = aws_db_subnet_group.new.name
  parameter_group_name    = aws_db_parameter_group.this.name
  vpc_security_group_ids  = [var.db_sg_id]
  storage_encrypted       = true
  backup_retention_period = 7
  skip_final_snapshot     = true
  multi_az                = var.multi_az
}
