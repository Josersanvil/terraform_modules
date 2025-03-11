resource "aws_security_group" "app_web_security_group" {
  name        = "${local.app_internal_name}-web-sg-${local.deployment_id}"
  description = "Allows access to HTTP and HTTPS from the web and full access within the VPC"
  vpc_id      = data.aws_vpc.app_vpc.id

  egress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = "0"
    protocol    = "-1"
    self        = "false"
    to_port     = "0"
  }

  ingress {
    description     = "Allow access on app port from the load balancer"
    protocol        = "tcp"
    self            = "false"
    from_port       = var.port
    to_port         = var.port
    security_groups = var.custom_load_balancer_arn == null ? aws_lb.app_alb[0].security_groups : data.aws_lb.custom_lb[0].security_groups
  }

  ingress {
    description = "Allows access to the Web server using HTTPS"
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = "443"
    protocol    = "tcp"
    self        = "false"
    to_port     = "443"
  }

  ingress {
    description = "Allows access to the Web server using HTTP"
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = "80"
    protocol    = "tcp"
    self        = "false"
    to_port     = "80"
  }

  ingress {
    description = "Allows all traffic coming from the VPC"
    from_port   = "0"
    protocol    = "-1"
    self        = "false"
    to_port     = "0"
    cidr_blocks = [local.app_vpc_cidr_block]
  }

  tags = {
    Name = "${local.app_internal_name}-web-sg-${local.deployment_id}"
  }
}

resource "aws_security_group" "load_balancer_security_group" {
  count = var.custom_load_balancer_arn == null ? 1 : 0

  name        = "${local.app_internal_name}-lb-sg-${local.deployment_id}"
  description = "Allows access to HTTP and HTTPS from the Internet and in any port within the VPC"
  vpc_id      = data.aws_vpc.app_vpc.id

  egress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = "0"
    protocol    = "-1"
    self        = "false"
    to_port     = "0"
  }

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = "443"
    protocol    = "tcp"
    self        = "false"
    to_port     = "443"
  }

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = "80"
    protocol    = "tcp"
    self        = "false"
    to_port     = "80"
  }

  ingress {
    description = "Allows all traffic coming from the VPC"
    from_port   = "0"
    protocol    = "-1"
    self        = "false"
    to_port     = "0"
    cidr_blocks = [local.app_vpc_cidr_block]
  }

  tags = {
    Name = "${local.app_internal_name}-lb-sg-${local.deployment_id}"
  }

}
