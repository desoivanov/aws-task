provider "aws" {
  //  access_key = var.aws_access_key
  //  secret_key = var.aws_secret_key
  shared_credentials_file = "%USERPROFILE%\\.aws\\credentials"
  profile                 = "default"
  region                  = var.aws_region
}


### Default VPC Reference - using default VPC instead of creating one for "demonstration purposes"

data "aws_vpc" "default_vpc" {
  id = var.aws_vpc_id
}
data "aws_internet_gateway" "default_ig" {
  internet_gateway_id = var.aws_vpc_gw_id
}
data "aws_subnet_ids" "default_subnets_ids" {
  vpc_id = data.aws_vpc.default_vpc.id
}

data "aws_subnet" "default_subnets" {
  for_each = data.aws_subnet_ids.default_subnets_ids.ids
  id       = each.value
}
### Security groups

resource "aws_security_group" "sg-database-servers" {
  name        = "database_sg"
  description = "Used in the terraform"
  vpc_id      = data.aws_vpc.default_vpc.id

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = [data.aws_vpc.default_vpc.cidr_block]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

### ECR

resource "aws_ecr_repository" "ecr-repo" {
  name = "default-repo"
}

resource "aws_ssm_parameter" "ecr-uri" {
  name  = "/codebuild/ECRURI"
  type  = "String"
  value = aws_ecr_repository.ecr-repo.repository_url
}