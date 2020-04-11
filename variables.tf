//variable "aws_access_key" {}
//variable "aws_secret_key" {}


#Cusotmize for test AWS Account , VPC is staying static , using default resources not recreating them.
variable "aws_vpc_id" {
  default = "vpc-e442888e"
}

variable "aws_vpc_gw_id" {
  default = "igw-ec529b87"
}

variable "aws_region" {
  default = "eu-central-1"
}
