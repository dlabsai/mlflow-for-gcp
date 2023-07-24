resource "aws_db_instance" "mlflow-db" {
  allocated_storage      = 10
  db_name                = "mlflowdb"
  identifier             = "${var.app_name}-${var.env}-db"
  engine                 = "postgres"
  engine_version         = "15.2"
  instance_class         = "db.t3.micro"
  username               = "mlflow_db_user"
  password               = random_password.db_password.result
  vpc_security_group_ids = [aws_security_group.allow_ingress_from_vpn_dlabs.id, aws_security_group.rds_sg.id]
  publicly_accessible    = "true"
  db_subnet_group_name   = aws_db_subnet_group.db_subnet_group.name
  skip_final_snapshot    = true
  storage_encrypted      = true

  depends_on = [aws_internet_gateway.main]

  tags = local.tags
}

resource "random_password" "db_password" {
  length           = 16
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}

resource "aws_ssm_parameter" "db_password" {
  name  = "/${var.app_name}/${var.env}/DB_PASSWORD"
  type  = "SecureString"
  value = random_password.db_password.result

  tags = local.tags
}

resource "aws_ssm_parameter" "db_url" {
  name  = "/${var.app_name}/${var.env}/DATABASE_URL"
  type  = "SecureString"
  value = "postgresql://${aws_db_instance.mlflow-db.username}:${random_password.db_password.result}@${aws_db_instance.mlflow-db.address}:5432/${aws_db_instance.mlflow-db.db_name}"

  tags = local.tags
}

resource "random_password" "mlflow_password" {
  length           = 16
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}

resource "aws_ssm_parameter" "mlflow_password" {
  name  = "/${var.app_name}/${var.env}/MLFLOW_TRACKING_PASSWORD"
  type  = "SecureString"
  value = random_password.mlflow_password.result

  tags = local.tags
}