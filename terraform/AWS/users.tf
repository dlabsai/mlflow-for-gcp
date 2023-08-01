data "aws_iam_policy" "bucket_access" {
  name = "AmazonS3FullAccess"
}

resource "aws_iam_user" "mlflow_s3" {
  name                 = "mlflow-access-s3"
  permissions_boundary = data.aws_iam_policy.bucket_access.arn

  tags = local.tags
}

resource "aws_iam_user_policy_attachment" "test-attach" {
  user       = aws_iam_user.mlflow_s3.name
  policy_arn = data.aws_iam_policy.bucket_access.arn
}

resource "aws_iam_access_key" "mlflow_s3" {
  user = aws_iam_user.mlflow_s3.name

}

resource "aws_ssm_parameter" "mlflow_key_id" {
  name  = "/${var.app_name}/${var.env}/AWS_ACCESS_KEY_ID"
  type  = "SecureString"
  value = aws_iam_access_key.mlflow_s3.id

  tags = local.tags
}

resource "aws_ssm_parameter" "mlflow_key_secret" {
  name  = "/${var.app_name}/${var.env}/AWS_SECRET_ACCESS_KEY"
  type  = "SecureString"
  value = aws_iam_access_key.mlflow_s3.secret

  tags = local.tags
}