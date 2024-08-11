resource "snowflake_storage_integration" "snowpipe_integration" {
  name                   = "formulaone_snowpipe_integration"
  type                   = "EXTERNAL_STAGE"
  storage_provider       = "S3"
  enabled                = true
  storage_aws_role_arn   = var.storage_aws_role_arn
  storage_allowed_locations = ["*"]
}
