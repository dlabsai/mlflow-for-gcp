resource "aws_s3_bucket" "mlflow-bucket" {
  bucket = "mlflow-bucket-${var.app_name}-${var.env}"

}

resource "aws_ssm_parameter" "mlflow-bucket_url" {
  name  = "/${var.app_name}/${var.env}/ARTIFACT_URL"
  type  = "SecureString"
  value = "s3://${aws_s3_bucket.mlflow-bucket.bucket}"

  tags = local.tags
}