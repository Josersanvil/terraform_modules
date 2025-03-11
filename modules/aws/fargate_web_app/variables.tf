variable "app_name" {
  type        = string
  description = "Name of the web app"
}

variable "vpc_id" {
  type        = string
  description = "ID of the VPC where the web app will be deployed"
}

variable "image" {
  type        = string
  description = "Docker image to use for the web app"
}

variable "port" {
  type        = number
  description = "Port where the web app will be listening in the container"
  default     = 80
}

variable "use_spot_instances" {
  type        = bool
  description = "Whether to use fargate spot instances as the capacity provider strategy of the ecs service"
  default     = false
}

variable "enable_container_insights" {
  type        = bool
  description = "Whether to enable container insights for the ECS cluster"
  default     = false
}

variable "environment_variables" {
  type = list(object({
    name  = string
    value = string
  }))
  description = "Environment variables to pass to the web app's container"
  default     = []
}

variable "cpu" {
  type        = number
  description = "CPU units to use for the web app"
  default     = 256
}

variable "memory" {
  type        = number
  description = "Memory to use for the web app"
  default     = 512
}

variable "route_53_domain_name" {
  type        = string
  description = "Optional domain name to use for the web app"
  default     = null
}

variable "acm_certificate_arn" {
  type        = string
  description = "Optional ACM certificate ARN to use for the web app, route_53_domain_name must be set"
  default     = null
}

variable "custom_load_balancer_arn" {
  type        = string
  description = "Optional custom load balancer ARN to use for the web app (e.g. for an existing load balancer)"
  default     = null
}

variable "subdomain_name" {
  type        = string
  description = "Optional subdomain to use for the url of the web app"
  default     = ""
}

variable "health_check_path" {
  type        = string
  description = "Path to use for the health check of the web app"
  default     = "/"
}
