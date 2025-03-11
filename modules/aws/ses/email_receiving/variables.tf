variable "domain_name" {
  description = "The name of the domain to be used for SES. Should match the SES domain identity name."
  type        = string
}

variable "route53_hosted_zone_name" {
  description = "The name of the Route53 hosted zone to be used for SES. If not provided, the domain name will be used."
  type        = string
  default     = null
}

variable "subdomain_name" {
  description = "The name of the subdomain to be used for the SES receiving record. If not provided, the domain name will be used."
  type        = string
  default     = null
}
