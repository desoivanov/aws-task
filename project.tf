resource "aws_iam_role" "cb-role" {
  name = "cb-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "codebuild.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "log-policy" {
  role = aws_iam_role.cb-role.name

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
      {
        "Effect": "Allow",
        "Resource": [
          "*"
        ],
        "Action": [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents",
          "ecr:GetAuthorizationToken",
          "ecr:GetDownloadUrlForLayer",
          "ecr:BatchGetImage",
          "ecr:BatchCheckLayerAvailability",
          "ecr:PutImage",
          "ecr:InitiateLayerUpload",
          "ecr:UploadLayerPart",
          "ecr:CompleteLayerUpload"
        ]
      },
      {
        "Effect": "Allow",
        "Action": [
          "s3:*"
        ],
        "Resource": [
          "${aws_s3_bucket.codepipeline_bucket.arn}",
          "${aws_s3_bucket.codepipeline_bucket.arn}/*"
        ]
      }
  ]
}
POLICY
}

resource "aws_codebuild_project" "aws-task-cb" {
  name         = "aws-task"
  service_role = aws_iam_role.cb-role.arn
  artifacts {
    type = "CODEPIPELINE"
  }
  environment {
    compute_type = "BUILD_GENERAL1_SMALL"
    image        = "aws/codebuild/standard:1.0"
    type         = "LINUX_CONTAINER"
  }
  source {
    type = "CODEPIPELINE"
  }
}