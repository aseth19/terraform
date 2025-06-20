#RDS Resources
resource "aws_db_subnet_group" "mariadb-subnets" {
  name        = "mariadb-subnets"
  description = "Amazon RDS subnet group"
  subnet_ids  = [aws_subnet.levelupvpc-private-1.id, aws_subnet.levelupvpc-private-2.id]
  tags = {
    Env       = "prod"
    yor_trace = "766cacab-1035-4bbe-9560-d8ca4db5d12a"
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
    Env       = "prod"
    yor_trace = "c226918a-3030-4fda-860d-ad058b5b4238"
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
    Env       = "prod"
    yor_trace = "f1a10d7b-bcb8-4840-91b4-cb8907a47913"
  }
  monitoring_interval        = true
  storage_encrypted          = true
  auto_minor_version_upgrade = true
}

output "rds" {
  value = aws_db_instance.levelup-mariadb.endpoint
}

