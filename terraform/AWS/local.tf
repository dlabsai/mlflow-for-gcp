locals {
  # Common tags to be assigned to all resources
  tags = {
    Name        = "mlflow-terraform"
    Environment = var.env
  }
}