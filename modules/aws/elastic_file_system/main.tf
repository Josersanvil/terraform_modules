data "aws_vpc"    "vpc" {
  id = var.vpc_id
}

data "aws_subnets" "vpc_subnets" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.vpc.id]
  }
}

resource "aws_efs_file_system" "file_system" {
  creation_token = var.file_system_name

  lifecycle_policy {
    transition_to_ia = "AFTER_30_DAYS"
  }

  lifecycle_policy {
    transition_to_primary_storage_class = "AFTER_1_ACCESS"
  }

  tags = {
    Name = var.file_system_name
  }
}

resource "aws_security_group" "file_system_sg" {
  name_prefix = "${var.file_system_name}_sg_"
  description = "Allows inbound access from the VPC on TCP port 2049"
  vpc_id      = data.aws_vpc.vpc.id

  ingress {
    description = "Allows inbound access from the VPC"
    from_port   = 2049
    to_port     = 2049
    protocol    = "tcp"
    cidr_blocks = [data.aws_vpc.vpc.cidr_block]
  }
}

resource "aws_efs_mount_target" "file_system" {
  for_each        = toset(data.aws_subnets.vpc_subnets.ids)
  file_system_id  = aws_efs_file_system.file_system.id
  subnet_id       = each.key
  security_groups = [aws_security_group.file_system_sg.id]
}

resource "time_sleep" "wait_for_efs_dns_propagation" {
  # Up to 90 seconds can elapse for the DNS records to propagate after creating a mount target
  count = var.wait_for_dns_propagation ? 1 : 0

  depends_on      = [aws_efs_mount_target.file_system]
  create_duration = "90s"
}
