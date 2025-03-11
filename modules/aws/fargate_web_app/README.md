# Fargate Web App

This module creates a simple stateless web app that runs in ECS with Fargate and an Application Load Balancer to route traffic to it. It is intended to be used as a starting point for a web app that runs in ECS.

Optionally, a Route53 record and ACM certificate can be created to point to the load balancer and secure it with HTTPS by passing in a Route53 zone ID.

The module creates the following resources:

* An ECS cluster
* An ECS task definition for the web app's container.
* An ECS service to run the task definition.
* An Application Load Balancer to route traffic to the service.
* An optional Route53 record to point to the load balancer. (Requires a Route53 hosted zone to be passed in.)
* An optional ACM certificate to use with the load balancer. (Requires a Route53 hosted zone to be passed in.)
* Security groups for the load balancer and the ECS tasks.
* An IAM role for the ECS tasks.
* An IAM role for the ECS service.

## Usage

```hcl
module "fargate_web_app" {
  source = "../../modules/fargate_web_app"

  # Required: The name of the web app.
  name = "my-web-app"

  # Optional Route53 zone to create a record in.
  route53_zone_id = "Z1234567890"

  # Optional ACM certificate to use with the load balancer.
  acm_certificate_arn = "arn:aws:acm:us-west-2:123456789012:certificate/12345678-1234-1234-1234-123456789012"

  # Optional tags to apply to all resources.
  tags = {
    Environment = "production"
  }

  # Required: The Docker image to use for the web app.
  image = "user/my-web-app:latest"

  # Required: The port the web app listens on.
  container_port = 80

  # Optional: The number of CPU units to allocate to the web app. Defaults to the minimum of 0.25 vCPU.
  container_cpu = 256

  # Optional: The amount of memory to allocate to the web app. Defaults to the minimum of 0.5 GB.
  container_memory = 512

  # Optional: The number of instances of the web app to run.
  desired_count = 2

  # Optional: The maximum number of instances of the web app to run.
  max_count = 4

  # Optional: The minimum number of instances of the web app to run.
  min_count = 1

  # Optional: The path to use for the health check. Defaults to "/".
  health_check_path = "/health"

  # Optional: The number of seconds between health checks.
  health_check_interval = 30

  # Optional: The number of seconds after a failed health check to wait before marking an instance as unhealthy.
  health_check_timeout = 5

  # Optional: The number of successful health checks required before an instance is marked as healthy.
  healthy_threshold = 5

  # Optional: The number of failed health checks required before an instance is marked as unhealthy.
  unhealthy_threshold = 2

  # Optional: The number of seconds to wait before the load balancer times out a request.
  idle_timeout = 60

  # Optional: The number of seconds to wait before the load balancer times out a connection.
  connection_draining_timeout = 60
```

<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |
| <a name="provider_random"></a> [random](#provider\_random) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_acm_certificate.app_domain](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/acm_certificate) | resource |
| [aws_acm_certificate_validation.app_domain_validation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/acm_certificate_validation) | resource |
| [aws_alb_listener.http_forward](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/alb_listener) | resource |
| [aws_alb_listener.http_redirect](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/alb_listener) | resource |
| [aws_alb_listener.https_forward](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/alb_listener) | resource |
| [aws_cloudwatch_log_group.app_logs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_ecs_cluster.app_cluster](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_cluster) | resource |
| [aws_ecs_cluster_capacity_providers.app_fargate_capacity_provider](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_cluster_capacity_providers) | resource |
| [aws_ecs_service.app](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_service) | resource |
| [aws_ecs_task_definition.app_task_definition](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_task_definition) | resource |
| [aws_iam_role.app_ecs_execution_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role.app_ecs_task_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_lb.app_alb](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb) | resource |
| [aws_lb_target_group.app_target](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_target_group) | resource |
| [aws_route53_record.app_domain_validation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record) | resource |
| [aws_route53_record.app_record](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record) | resource |
| [aws_security_group.app_web_security_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group.load_balancer_security_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_service_discovery_private_dns_namespace.app_namespace](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/service_discovery_private_dns_namespace) | resource |
| [random_string.deployment_id](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/string) | resource |
| [aws_lb.custom_lb](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/lb) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |
| [aws_route53_zone.app-domain](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/route53_zone) | data source |
| [aws_subnets.app_vpc_subnets](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/subnets) | data source |
| [aws_vpc.app_vpc](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/vpc) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_acm_certificate_arn"></a> [acm\_certificate\_arn](#input\_acm\_certificate\_arn) | Optional ACM certificate ARN to use for the web app, route\_53\_domain\_name must be set | `string` | `null` | no |
| <a name="input_app_name"></a> [app\_name](#input\_app\_name) | Name of the web app | `string` | n/a | yes |
| <a name="input_cpu"></a> [cpu](#input\_cpu) | CPU units to use for the web app | `number` | `256` | no |
| <a name="input_custom_load_balancer_arn"></a> [custom\_load\_balancer\_arn](#input\_custom\_load\_balancer\_arn) | Optional custom load balancer ARN to use for the web app (e.g. for an existing load balancer) | `string` | `null` | no |
| <a name="input_enable_container_insights"></a> [enable\_container\_insights](#input\_enable\_container\_insights) | Whether to enable container insights for the ECS cluster | `bool` | `false` | no |
| <a name="input_environment_variables"></a> [environment\_variables](#input\_environment\_variables) | Environment variables to pass to the web app's container | <pre>list(object({<br/>    name  = string<br/>    value = string<br/>  }))</pre> | `[]` | no |
| <a name="input_health_check_path"></a> [health\_check\_path](#input\_health\_check\_path) | Path to use for the health check of the web app | `string` | `"/"` | no |
| <a name="input_image"></a> [image](#input\_image) | Docker image to use for the web app | `string` | n/a | yes |
| <a name="input_memory"></a> [memory](#input\_memory) | Memory to use for the web app | `number` | `512` | no |
| <a name="input_port"></a> [port](#input\_port) | Port where the web app will be listening in the container | `number` | `80` | no |
| <a name="input_route_53_domain_name"></a> [route\_53\_domain\_name](#input\_route\_53\_domain\_name) | Optional domain name to use for the web app | `string` | `null` | no |
| <a name="input_subdomain_name"></a> [subdomain\_name](#input\_subdomain\_name) | Optional subdomain to use for the url of the web app | `string` | `""` | no |
| <a name="input_use_spot_instances"></a> [use\_spot\_instances](#input\_use\_spot\_instances) | Whether to use fargate spot instances as the capacity provider strategy of the ecs service | `bool` | `false` | no |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | ID of the VPC where the web app will be deployed | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_app_ecs_cluster_name"></a> [app\_ecs\_cluster\_name](#output\_app\_ecs\_cluster\_name) | The name of the app ECS cluster. Can be used to update the service of the application. |
| <a name="output_app_ecs_service_name"></a> [app\_ecs\_service\_name](#output\_app\_ecs\_service\_name) | The name of the app ECS service. Can be used to update the service of the application. |
| <a name="output_app_ecs_task_role_arn"></a> [app\_ecs\_task\_role\_arn](#output\_app\_ecs\_task\_role\_arn) | The ARN of the app ECS task role. Can be used to attach custom policies to the role. |
| <a name="output_app_ecs_task_role_name"></a> [app\_ecs\_task\_role\_name](#output\_app\_ecs\_task\_role\_name) | The name of the app ECS task role. Can be used to attach custom policies to the role. |
| <a name="output_app_hostname"></a> [app\_hostname](#output\_app\_hostname) | The hostname of the application. |
| <a name="output_app_target_group_arn"></a> [app\_target\_group\_arn](#output\_app\_target\_group\_arn) | The ARN of the app target group. Can be used to create a listener for the load balancer. |
| <a name="output_deployment_id"></a> [deployment\_id](#output\_deployment\_id) | The randomly generated deployment ID. Can be used to identify the resources created by this module. |
<!-- END_TF_DOCS -->
