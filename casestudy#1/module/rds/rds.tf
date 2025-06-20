
#Call VPC Module First to get the Subnet IDs
# module "levelup-vpc" {
#     source      = "../vpc"

#     ENVIRONMENT = var.ENVIRONMENT
#     AWS_REGION  = var.AWS_REGION
# }

#Define Subnet Group for RDS Service
resource "aws_db_subnet_group" "levelup-rds-subnet-group" {

  name        = "${var.ENVIRONMENT}-levelup-db-snet"
  description = "Allowed subnets for DB cluster instances"
  subnet_ids = [
    "${var.vpc_private_subnet1}",
    "${var.vpc_private_subnet2}",
  ]
  tags = {
    Name      = "${var.ENVIRONMENT}_levelup_db_subnet"
    Env       = "prod"
    yor_trace = "3b00dd79-51c5-40a0-bc5e-9772d0acb8d3"
  }
}

#Define Security Groups for RDS Instances
resource "aws_security_group" "levelup-rds-sg" {

  name        = "${var.ENVIRONMENT}-levelup-rds-sg"
  description = "Created by LevelUp"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["${var.RDS_CIDR}"]

  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name      = "${var.ENVIRONMENT}-levelup-rds-sg"
    Env       = "prod"
    yor_trace = "03b2f2f3-d669-4fcb-a8f8-6271210b969f"
  }
}

resource "aws_db_instance" "levelup-rds" {
  identifier                 = "${var.ENVIRONMENT}-levelup-rds"
  allocated_storage          = var.LEVELUP_RDS_ALLOCATED_STORAGE
  storage_type               = "gp2"
  engine                     = var.LEVELUP_RDS_ENGINE
  engine_version             = var.LEVELUP_RDS_ENGINE_VERSION
  instance_class             = var.DB_INSTANCE_CLASS
  backup_retention_period    = var.BACKUP_RETENTION_PERIOD
  publicly_accessible        = var.PUBLICLY_ACCESSIBLE
  username                   = var.LEVELUP_RDS_USERNAME
  password                   = var.LEVELUP_RDS_PASSWORD
  vpc_security_group_ids     = [aws_security_group.levelup-rds-sg.id]
  db_subnet_group_name       = aws_db_subnet_group.levelup-rds-subnet-group.name
  multi_az                   = true
  auto_minor_version_upgrade = true
  storage_encrypted          = true
  monitoring_interval        = true
  tags = {
    Env       = "prod"
    yor_trace = "2db6ceee-680e-4e46-8799-339e389869df"
  }
}

output "rds_prod_endpoint" {
  value = aws_db_instance.levelup-rds.endpoint
}