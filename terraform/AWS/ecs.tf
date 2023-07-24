resource "aws_ecs_cluster" "mlflow_ecs" {
  name = "${var.app_name}-cluster"

  setting {
    name  = "containerInsights"
    value = "enabled"
  }

  tags = local.tags
}

resource "aws_ecs_cluster_capacity_providers" "base" {
  cluster_name = aws_ecs_cluster.mlflow_ecs.name

  capacity_providers = ["FARGATE"]

  default_capacity_provider_strategy {
    weight            = 10
    base              = 1
    capacity_provider = "FARGATE"
  }
}

resource "aws_ecs_service" "mlflow" {
  health_check_grace_period_seconds = 0
  name                              = var.ecs_service_name
  enable_ecs_managed_tags           = true
  propagate_tags                    = "NONE"
  cluster                           = aws_ecs_cluster.mlflow_ecs.id
  task_definition                   = "${aws_ecs_task_definition.mlflow.family}:${aws_ecs_task_definition.mlflow.revision}"
  desired_count                     = 1

  tags = local.tags

  depends_on = [
    aws_lb.mlflow,
    aws_alb_listener.mlflow,
    aws_lb_target_group.mlflow,
    aws_lb_listener_rule.mlflow,
    aws_ecs_task_definition.mlflow
  ]

  deployment_circuit_breaker {
    enable   = true
    rollback = true
  }

  deployment_controller {
    type = "ECS"
  }

  capacity_provider_strategy {
    base              = 1
    capacity_provider = "FARGATE"
    weight            = 10
  }


  load_balancer {
    container_name   = var.ecs_task_name
    container_port   = 8080
    target_group_arn = aws_lb_target_group.mlflow.arn
  }

  network_configuration {
    security_groups = [
      aws_security_group.ecs_sg.id,
      aws_security_group.rds_sg.id,
    ]

    subnets = [
      aws_subnet.private_subnet_a.id,
      aws_subnet.private_subnet_b.id,
    ]
  }
}

