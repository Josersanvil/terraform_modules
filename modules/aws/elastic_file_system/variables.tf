variable "vpc_id" {
  description = "The ID of the VPC in which to create the EFS file system"
  type        = string
}

variable "file_system_name" {
  description = "The name of the EFS file system"
  type        = string
}

variable "wait_for_dns_propagation" {
  description = "If true, waits 90s for the DNS records to propagate after creating the mount targets"
  type        = bool
  default     = true
}
