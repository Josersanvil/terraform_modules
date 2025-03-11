resource "random_string" "deployment_id" {
  length  = 6
  lower   = true
  numeric = true
  special = false
  upper   = false
}

data "aws_region" "current" {}

data "aws_vpc" "app_vpc" {
  id = var.vpc_id
}

data "aws_subnets" "app_vpc_subnets" {
  filter {
    name   = "vpc-id"
    values = [var.vpc_id]
  }
}

locals {
  app_vpc_id          = data.aws_vpc.app_vpc.id
  app_vpc_cidr_block  = data.aws_vpc.app_vpc.cidr_block
  app_vpc_subnets_ids = data.aws_subnets.app_vpc_subnets.ids
  deployment_id       = random_string.deployment_id.result
  app_internal_name   = lower(replace(var.app_name, "/\\W+/", "-"))
}
