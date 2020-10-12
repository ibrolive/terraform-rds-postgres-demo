# Database Instance Cheatsheet:
provider "aws" {
  #version = "~> 2.0"
  region = var.region
}


##################################################################################
# DB instance
##################################################################################
resource "aws_db_instance" "postgresdb" {
  allocated_storage        = 256 # gigabytes
  backup_retention_period  = 7   # in days
  db_subnet_group_name     = aws_db_subnet_group.default.name
  engine                   = "postgres"
  engine_version           = "9.5.4"
  identifier               = "postgresdb"
  instance_class           = "db.r3.large"
  multi_az                 = false
  name                     = "postgresdb"
  #parameter_group_name     = "postgresparamgroup1" # if you have tuned it
  password                 = "${trimspace(file("${path.module}/secrets/postgresdb-password.txt"))}"
  port                     = 5432
  publicly_accessible      = true
  storage_encrypted        = true # you should always do this
  storage_type             = "gp2"
  username                 = "postgresdb"
  vpc_security_group_ids   = ["${aws_security_group.AWS_VPC_Security_Group.id}"]
}

# https://blog.faraday.io/how-to-create-an-rds-instance-with-terraform/

