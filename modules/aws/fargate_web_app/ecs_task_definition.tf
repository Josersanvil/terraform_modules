resource "aws_cloudwatch_log_group" "app_logs" {
  name              = "/${local.app_internal_name}/${local.deployment_id}"
  retention_in_days = 7
}

resource "aws_ecs_task_definition" "app_task_definition" {
  cpu                      = var.cpu
  memory                   = var.memory
  execution_role_arn       = aws_iam_role.app_ecs_execution_role.arn
  task_role_arn            = aws_iam_role.app_ecs_task_role.arn
  family                   = "${local.app_internal_name}-${local.deployment_id}"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]

  container_definitions = jsonencode([
    {
      name      = local.app_internal_name
      essential = true
      image     = var.image
      portMappings = [
        {
          containerPort = var.port
          hostPort      = var.port
          protocol      = "tcp"
        }
      ]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = aws_cloudwatch_log_group.app_logs.name
          awslogs-region        = data.aws_region.current.name
          awslogs-stream-prefix = "ecs"
        }
      },
      environment = var.environment_variables,
      healthCheck = {
        command     = ["CMD-SHELL", "curl -f http://localhost:${var.port}${var.health_check_path} || exit 1"]
        interval    = 10
        retries     = 3
        startPeriod = 60
        timeout     = 5
      }
    },
  ])

  runtime_platform {
    cpu_architecture        = "X86_64"
    operating_system_family = "LINUX"
  }
}
