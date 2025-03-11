variable "name" {
  type        = string
  description = "The name of the VPC environment. This will be used to name all resources created by this module."
}

variable "vpc_cidr_block" {
  type        = string
  description = "The CIDR block for the VPC."
}

variable "availability_zones" {
  type        = list(string)
  description = "The availability zones to use for the subnets."
}
