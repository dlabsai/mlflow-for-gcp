data "aws_iam_policy" "cloud_watch" {
  name = "AWSOpsWorksCloudWatchLogs"
}

data "aws_iam_policy" "ecs_task_execution" {
  name = "AmazonECSTaskExecutionRolePolicy"
}

resource "aws_iam_role" "ecs_mlflow" {
  name = "ECSMlFlow"

  managed_policy_arns = [
    aws_iam_policy.access_ssm.arn,
    data.aws_iam_policy.cloud_watch.arn,
    data.aws_iam_policy.ecs_task_execution.arn
  ]

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
      },
    ]
  })

  tags = local.tags
}

resource "aws_iam_policy" "access_ssm" {
  name        = "AccessSSM_MlFlow"
  path        = "/"
  description = "Policy for accessing SSM for MlFlow"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "ssm:GetParameter",
          "ssm:GetParameters",
          "ssm:GetParametersByPath"
        ]
        Effect   = "Allow"
        Resource = "arn:aws:ssm:*:*:*"
      },
    ]
  })
}