resource "aws_ecs_task_definition" "mlflow" {
  execution_role_arn = aws_iam_role.ecs_mlflow.arn
  family       = var.ecs_task_name
  memory       = "3072"
  cpu          = "1024"
  network_mode = "awsvpc"
  requires_compatibilities = [
    "FARGATE",
  ]

  container_definitions = jsonencode(
    [
      {
        environment = [
          {
            name  = "DB_PORT"
            value = "5432"
          },
          {
            name  = "MLFLOW_TRACKING_USERNAME"
            value = "mlflow-user"
          },
        ]
        essential = true
        image     = "${aws_ecr_repository.mlflow_ecr.repository_url}:latest"
        logConfiguration = {
          logDriver = "awslogs"
          options = {
            awslogs-create-group  = "true"
            awslogs-group         = "/ecs/${var.ecs_service_name}/${var.ecs_task_name}"
            awslogs-region        = "eu-central-1"
            awslogs-stream-prefix = "ecs"
          }
        }
        name = var.ecs_task_name
        portMappings = [
          {
            appProtocol   = "http"
            containerPort = 8080
            hostPort      = 8080
            name          = "${var.ecs_task_name}-8080-tcp"
            protocol      = "tcp"
          },
        ]
        secrets = [
          {
            name      = "AWS_ACCESS_KEY_ID"
            valueFrom = "/${var.app_name}/${var.env}/AWS_ACCESS_KEY_ID"
          },
          {
            name      = "AWS_SECRET_ACCESS_KEY"
            valueFrom = "/${var.app_name}/${var.env}/AWS_SECRET_ACCESS_KEY"
          },
          {
            name      = "MLFLOW_TRACKING_PASSWORD"
            valueFrom = "/${var.app_name}/${var.env}/MLFLOW_TRACKING_PASSWORD"
          },
          {
            name      = "ARTIFACT_URL"
            valueFrom = "/${var.app_name}/${var.env}/ARTIFACT_URL"
          },
          {
            name      = "DATABASE_URL"
            valueFrom = "/${var.app_name}/${var.env}/DATABASE_URL"
          },
        ]
      },
    ]
  )

  runtime_platform {
    cpu_architecture        = "X86_64"
    operating_system_family = "LINUX"
  }
  tags = local.tags
}