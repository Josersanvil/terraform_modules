output "vpc_id" {
  value = aws_vpc.vpc.id
}

output "public_subnet_ids" {
  value = {
    for subnet in aws_subnet.public_subnet :
    subnet.availability_zone => subnet.id
  }
}

output "private_subnet_ids" {
  value = {
    for subnet in aws_subnet.private_subnet :
    subnet.availability_zone => subnet.id
  }
}

output "available_zones" {
  value = var.availability_zones
}

output "default_security_group_id" {
  value = aws_security_group.default.id
}
