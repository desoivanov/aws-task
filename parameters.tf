resource "random_string" "db-password" {
  length  = 32
  special = false
  lower   = true
  upper   = true
}

resource "random_string" "db-username" {
  length  = 8
  special = false
  lower   = true
  upper   = true
}

### SSM Resources

resource "aws_ssm_parameter" "master-db-user" {
  name  = "/default/database/user/master"
  type  = "String"
  value = random_string.db-username.result
}

resource "aws_ssm_parameter" "master-db-password" {
  name  = "/default/database/password/master"
  type  = "SecureString"
  value = random_string.db-password.result
}