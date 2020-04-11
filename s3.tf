resource "random_string" "suffix" {
  length  = 8
  special = false
  upper   = false
}

resource "aws_s3_bucket" "web-bucket" {
  bucket = "aws-web-tf-${random_string.suffix.result}"
  acl    = "public-read"
  website {
    index_document = "index.html"
  }
}