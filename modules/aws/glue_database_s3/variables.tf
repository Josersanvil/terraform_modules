variable "database_name" {
  description = "The name of the Glue catalog database to create. Usually the name of the project"
  type        = string
}


variable "s3_bucket_name" {
  description = "The name of the S3 bucket where the data is stored"
  type        = string
}

variable "s3_bucket_prefix" {
  description = "The path to where the data is stored in the S3 bucket"
  type        = string
  default     = ""
}

variable "crawler_tables_prefix" {
  description = "The prefix to add to the tables created by the crawler"
  type        = string
  default     = ""
}

variable "crawler_schedule" {
  description = "The schedule for the crawler"
  type        = string
  default     = "cron(0 0 * * ? *)" # Default to daily at midnight
}

variable "iam_role_name" {
  description = "The name of the IAM role to use for the crawler. Defaults to FullETLAccess"
  type        = string
  default     = "FullETLAccess"
}
