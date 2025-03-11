# VPC:
resource "aws_vpc" "vpc" {
  cidr_block           = var.vpc_cidr_block
  instance_tenancy     = "default"
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags = {
    Name = "${var.name} VPC"
  }
}


# VPC Subnets:

## Create Public subnets using a count loop in the different availability zones:
resource "aws_subnet" "public_subnet" {
  /*
        A subnet is a range of IP addresses in your VPC.
        The public subnet is reachable from the Internet.
        It can access the Internet directly from the Internet Gateway.
  */

  count             = length(var.availability_zones)
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = cidrsubnet(aws_vpc.vpc.cidr_block, 8, count.index)
  availability_zone = var.availability_zones[count.index]

  tags = {
    Name = "${var.name} Public Subnet ${var.availability_zones[count.index]}"
  }
}

## Create Private subnets using a count loop in the different availability zones:
resource "aws_subnet" "private_subnet" {
  /*
    The private subnet is not reachable from the Internet,
    it can only be accessed from within the VPC.
    It can access the Internet through the NAT gateway.
  */

  count = length(var.availability_zones)

  vpc_id            = aws_vpc.vpc.id
  cidr_block        = cidrsubnet(aws_vpc.vpc.cidr_block, 8, count.index + 2)
  availability_zone = var.availability_zones[count.index]

  tags = {
    Name = "${var.name} Private Subnet ${var.availability_zones[count.index]}"
  }
}

# Network Gateways

## Internet Gateway for the public subnet:
resource "aws_internet_gateway" "internet_gateway" {
  /*
    An Internet gateway is a horizontally scaled, redundant, and highly
    available VPC component that allows communication between instances in
    your VPC and the internet.
    The public subnet is connected to the internet via the Internet Gateway.
  */

  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "${var.name} Internet Gateway"
  }
}

## Elastic IP for the NAT Gateway:
resource "aws_eip" "nat_gateway_eip" {

  vpc = true

  tags = {
    Name = "${var.name} NAT Gateway EIP"
  }
}

## NAT Gateway for the private subnet:
resource "aws_nat_gateway" "nat_gateway" {
  /*
    A NAT Gateway is a highly available AWS managed service that provides
    outbound internet access for resources within a private subnet in an AWS
    VPC. The NAT gateway forwards traffic from instances in the private
    subnet to the internet or other AWS services, and then sends the response
    back to the instances.
  */

  allocation_id = aws_eip.nat_gateway_eip.id
  subnet_id     = aws_subnet.public_subnet[0].id

  depends_on = [aws_internet_gateway.internet_gateway]

  tags = {
    Name = "${var.name} NAT Gateway"
  }
}

# Routing Tables

## Routing Table for the public subnet:
resource "aws_route_table" "public_route_table" {
  /*
    A route table contains a set of rules, called routes, that are used to
    determine where a specific set of IP traffic from your subnet or gateway
    is directed.

    This one directs all traffic to the Internet Gateway.
  */

  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0" # All traffic
    gateway_id = aws_internet_gateway.internet_gateway.id
  }

  tags = {
    Name = "${var.name} Public Route Table"
  }
}

## Routing Table for the private subnet:
resource "aws_route_table" "private_route_table" {
  /* 
    This one directs all traffic to the NAT Gateway.
  */
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.internet_gateway.id
  }
  tags = {
    Name = "${var.name} Private Route Table"
  }
}

## Routing Table Association for the public subnet:
resource "aws_route_table_association" "public_route_table_association" {
  count          = length(var.availability_zones)
  subnet_id      = aws_subnet.public_subnet[count.index].id
  route_table_id = aws_route_table.public_route_table.id
}

## Routing Table Association for the private subnet:
resource "aws_route_table_association" "private_route_table_association" {
  count          = 2
  subnet_id      = aws_subnet.private_subnet[count.index].id
  route_table_id = aws_route_table.private_route_table.id
}

# Security Groups

## A default security group for the VPC:
resource "aws_security_group" "default" {
  name        = "${var.name} Default Security Group"
  description = "Default security group for the VPC"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    description = "Allow all inbound traffic from the VPC"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    self        = true
  }

  egress {
    description = "Allow all outbound traffic from the VPC"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    self        = true
  }

  depends_on = [aws_vpc.vpc]

  tags = {
    Name = "${var.name} VPC Default Security Group"
  }
}
