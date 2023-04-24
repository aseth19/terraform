#RDS Resources
resource "aws_db_subnet_group" "mariadb-subnets" {
  name        = "mariadb-subnets"
  description = "Amazon RDS subnet group"
  subnet_ids  = [aws_subnet.levelupvpc-private-1.id, aws_subnet.levelupvpc-private-2.id]
  tags = {
    yor_trace = "49d5211e-0d98-4c6a-a145-13b1256317a6"
  }
}

#RDS Parameters
resource "aws_db_parameter_group" "levelup-mariadb-parameters" {
  name        = "levelup-mariadb-parameters"
  family      = "mariadb10.4"
  description = "MariaDB parameter group"

  parameter {
    name  = "max_allowed_packet"
    value = "16777216"
  }
  tags = {
    yor_trace = "23bf16cd-b05a-49ee-bdda-a1093258379b"
  }
}

#RDS Instance properties
resource "aws_db_instance" "levelup-mariadb" {
  allocated_storage       = 20 # 20 GB of storage
  engine                  = "mariadb"
  engine_version          = "10.4.8"
  instance_class          = "db.t2.micro" # use micro if you want to use the free tier
  identifier              = "mariadb"
  name                    = "mariadb"
  username                = "root"       # username
  password                = "mariadb141" # password
  db_subnet_group_name    = aws_db_subnet_group.mariadb-subnets.name
  parameter_group_name    = aws_db_parameter_group.levelup-mariadb-parameters.name
  multi_az                = true
  vpc_security_group_ids  = [aws_security_group.allow-mariadb.id]
  storage_type            = "gp2"
  backup_retention_period = 30                                                # how long you’re going to keep your backups
  availability_zone       = aws_subnet.levelupvpc-private-1.availability_zone # prefered AZ
  skip_final_snapshot     = true                                              # skip final snapshot when doing terraform destroy

  tags = {
    Name      = "levelup-mariadb"
    yor_trace = "0cb14a1d-969b-4ff3-9fe3-fc726cce9fb8"
  }
  monitoring_interval        = true
  storage_encrypted          = true
  auto_minor_version_upgrade = true
}

output "rds" {
  value = aws_db_instance.levelup-mariadb.endpoint
}

