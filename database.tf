resource "aws_db_subnet_group" "default" {
  name       = "main"
  subnet_ids = data.aws_subnet_ids.default_subnets_ids.ids

  tags = {
    Name = "RDS_Subnet_TF"
  }
}

resource "aws_db_parameter_group" "default_params" {
  name   = "mysql-default"
  family = "mysql5.7"

  parameter {
    name  = "character_set_server"
    value = "utf8"
  }

  parameter {
    name  = "character_set_client"
    value = "utf8"
  }
}

resource "aws_db_instance" "DB01-PROD-TF" {
  identifier = "database-prod-tf"
  #used during testing of python script...
  #publicly_accessible = "true"
  allocated_storage    = 20
  storage_type         = "gp2"
  engine               = "mysql"
  engine_version       = "5.7"
  instance_class       = "db.t3.micro"
  username             = aws_ssm_parameter.master-db-user.value
  password             = aws_ssm_parameter.master-db-password.value
  parameter_group_name = aws_db_parameter_group.default_params.name
  #dont need this for example
  storage_encrypted = false
  #dont need this for example
  multi_az = false
  #dont need this to be true for example it will allow us to destroy resrouces at will
  skip_final_snapshot    = true
  vpc_security_group_ids = [aws_security_group.sg-database-servers.id]
  db_subnet_group_name   = aws_db_subnet_group.default.id
}