resource "aws_service_discovery_private_dns_namespace" "app_namespace" {
  name = "${local.app_internal_name}.${local.deployment_id}"
  vpc  = data.aws_vpc.app_vpc.id
}

resource "aws_ecs_cluster" "app_cluster" {
  name = "${local.app_internal_name}-${local.deployment_id}"

  configuration {
    execute_command_configuration {
      logging = "DEFAULT"
    }
  }

  setting {
    name  = "containerInsights"
    value = var.enable_container_insights ? "enabled" : "disabled"
  }

  service_connect_defaults {
    namespace = aws_service_discovery_private_dns_namespace.app_namespace.arn
  }
}

resource "aws_ecs_cluster_capacity_providers" "app_fargate_capacity_provider" {
  cluster_name       = aws_ecs_cluster.app_cluster.name
  capacity_providers = ["FARGATE", "FARGATE_SPOT"]

  default_capacity_provider_strategy {
    base              = 1
    weight            = 100
    capacity_provider = "FARGATE"
  }
}
