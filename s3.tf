resource "random_string" "suffix" {
  length  = 8
  special = false
  upper   = false
}

resource "aws_s3_bucket" "web-bucket" {
  bucket = "aws-web-tf-${random_string.suffix.result}"
  acl    = "public-read"

  policy = <<EOF
{
  "Version": "2008-10-17",
  "Statement": [
    {
      "Sid": "PublicReadForGetBucketObjects",
      "Effect": "Allow",
      "Principal": {
        "AWS": "*"
      },
      "Action": "s3:GetObject",
      "Resource": "arn:aws:s3:::aws-web-tf-${random_string.suffix.result}/*"
    }
  ]
}
EOF

  website {
    index_document = "index.html"
  }
}