resource "aws_ecs_service" "app" {

  name                               = "${local.app_internal_name}-service"
  cluster                            = aws_ecs_cluster.app_cluster.arn
  task_definition                    = aws_ecs_task_definition.app_task_definition.arn
  platform_version                   = "LATEST"
  propagate_tags                     = "TASK_DEFINITION"
  scheduling_strategy                = "REPLICA"
  force_new_deployment               = true
  deployment_maximum_percent         = 200
  deployment_minimum_healthy_percent = 100
  desired_count                      = 1
  enable_ecs_managed_tags            = true
  enable_execute_command             = false
  health_check_grace_period_seconds  = 360

  capacity_provider_strategy {
    base              = "0"
    capacity_provider = var.use_spot_instances ? "FARGATE_SPOT" : "FARGATE"
    weight            = "1"
  }

  deployment_circuit_breaker {
    enable   = "true"
    rollback = "true"
  }

  deployment_controller {
    type = "ECS"
  }

  load_balancer {
    container_name   = local.app_internal_name
    container_port   = var.port
    target_group_arn = aws_lb_target_group.app_target.arn
  }

  network_configuration {
    assign_public_ip = "true"
    security_groups  = [aws_security_group.app_web_security_group.id]
    subnets          = local.app_vpc_subnets_ids
  }

}
