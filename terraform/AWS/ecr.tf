resource "aws_ecr_repository" "mlflow_ecr" {
  name                 = "${var.app_name}-${var.env}-image"
  image_tag_mutability = "MUTABLE"
  force_delete         = true

  image_scanning_configuration {
    scan_on_push = true
  }
  encryption_configuration {
    encryption_type = "AES256"
  }
  tags = local.tags
}