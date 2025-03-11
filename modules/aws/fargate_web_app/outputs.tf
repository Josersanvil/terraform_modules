output "deployment_id" {
  description = "The randomly generated deployment ID. Can be used to identify the resources created by this module."
  value       = random_string.deployment_id.result
}

output "app_target_group_arn" {
  description = "The ARN of the app target group. Can be used to create a listener for the load balancer."
  value       = aws_lb_target_group.app_target.arn
}

output "app_ecs_task_role_arn" {
  description = "The ARN of the app ECS task role. Can be used to attach custom policies to the role."
  value       = aws_iam_role.app_ecs_task_role.arn
}

output "app_ecs_task_role_name" {
  description = "The name of the app ECS task role. Can be used to attach custom policies to the role."
  value       = aws_iam_role.app_ecs_task_role.name
}

output "app_hostname" {
  description = "The hostname of the application."
  value       = var.route_53_domain_name == null ? var.custom_load_balancer_arn == null ? aws_lb.app_alb[0].dns_name : data.aws_lb.custom_lb[0].dns_name : var.custom_load_balancer_arn == null ? aws_route53_record.app_record[0].fqdn : var.subdomain_name != "" ? "${var.subdomain_name}.${var.route_53_domain_name}" : var.route_53_domain_name
}

output "app_ecs_cluster_name" {
  description = "The name of the app ECS cluster. Can be used to update the service of the application."
  value       = aws_ecs_cluster.app_cluster.name
}

output "app_ecs_service_name" {
  description = "The name of the app ECS service. Can be used to update the service of the application."
  value       = aws_ecs_service.app.name
}
