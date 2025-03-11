variable "domain_name" {
  description = "The domain name to use for the ACM certificate"
  type        = string
}

variable "hosted_zone_name" {
  description = "The name of the Route53 hosted zone in which to create the ACM certificate's DNS record"
  type        = string
}

variable "subject_alternative_names" {
  description = "A list of additional domain names or patterns to use for the ACM certificate"
  type        = list(string)
  default     = []
}

variable "allow_overwrite" {
  description = "Whether to allow overwriting an existing DNS record, useful when using the same domain name for multiple ACM certificates"
  type        = bool
  default     = false
}
