variable "snowflake_account" {
  description = "The Snowflake account identifier"
  type        = string
  sensitive   = true
}

variable "snowflake_user" {
  description = "The Snowflake username"
  type        = string
  sensitive   = true
}

variable "snowflake_password" {
  description = "The Snowflake password"
  type        = string
  sensitive   = true
}

variable "snowflake_region" {
  description = "The Snowflake region"
  type        = string
  sensitive   = true
}

variable "snowflake_role" {
  description = "The Snowflake role"
  type        = string
  sensitive   = true
}

variable "snowflake_warehouse" {
  description = "The Snowflake warehouse"
  type        = string
  sensitive   = true
}

variable "s3_bucket_url" {
  type        = string
  sensitive   = true
}

variable "storage_aws_role_arn" {
  type        = string
  sensitive   = true
}