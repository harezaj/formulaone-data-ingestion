resource "snowflake_stage" "racedetails_s3_stage" {
  name                    = "racedetails_s3_stage"
  database                = "formulaone_staging"
  schema                  = "processengine"
  url                     = var.s3_bucket_url
  storage_integration     = "formulaone_snowpipe_integration"
  file_format             = snowflake_file_format.csv_format.name
}
