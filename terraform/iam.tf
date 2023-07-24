resource "aws_iam_role" "web_server" {
  name = local.role_name
  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "sts:AssumeRole"
            ],
            "Principal": {
                "Service": [
                    "ec2.amazonaws.com"
                ]
            }
        }
    ]
}
EOF
}

resource "aws_iam_instance_profile" "web_server" {
  name = local.role_name
  role = aws_iam_role.web_server.name
}

resource "aws_iam_policy" "s3_access" {
  name        = "s3_access"
  policy = data.aws_iam_policy_document.s3_access.json
}

data "aws_iam_policy_document" "s3_access" {
  statement {
    sid       = "Stmt1689204184030"
    effect    = "Allow"
    resources = ["arn:aws:s3:::dev-bucket-440546640008/*"]
    actions   = ["s3:GetObject","s3:HeadObject", "s3:ListBucket"]
  }
}

resource "aws_iam_policy_attachment" "test-attach" {
  name       = "s3_access_attachment"
  roles      = [aws_iam_role.web_server.name]
  policy_arn = aws_iam_policy.s3_access.arn
}

resource "aws_iam_policy" "secret_access" {
  name        = "secret_access"
  policy = data.aws_iam_policy_document.secret_access.json
}

data "aws_iam_policy_document" "secret_access" {
  statement {
    sid       = "Stmt1689283837490"
    effect    = "Allow"
    resources = [module.db.db_instance_master_user_secret_arn]
    actions   = ["secretsmanager:GetSecretValue"]
  }
  statement {
    sid       = "Stmt1689286785957"
    effect    = "Allow"
    resources = ["arn:aws:ssm:us-east-1:440546640008:parameter/staging/rds_info"]
    actions   = ["ssm:GetParameter"]
  }
}

resource "aws_iam_policy_attachment" "secret_access" {
  name       = "secret_access_attachment"
  roles      = [aws_iam_role.web_server.name]
  policy_arn = aws_iam_policy.secret_access.arn
}