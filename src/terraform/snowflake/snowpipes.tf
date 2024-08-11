resource "snowflake_pipe" "racedetails_snowpipe" {
  name        = "racedetails_snowpipe"
  database    = "formulaone_staging"
  schema      = "processengine"
  comment     = "Pipe to ingest data from S3 into the racedetails staging table"
  auto_ingest = true

  copy_statement = <<EOF
COPY INTO formulaone_staging.processengine.racedetails
FROM @formulaone_staging.processengine.racedetails_s3_stage
FILE_FORMAT = (TYPE = 'CSV' SKIP_HEADER = 1 FIELD_OPTIONALLY_ENCLOSED_BY = '"' ERROR_ON_COLUMN_COUNT_MISMATCH = FALSE);
EOF
}
