resource "snowflake_file_format" "csv_format" {
  name               = "csv_format"
  database           = "formulaone_staging"
  schema             = "processengine"
  format_type        = "CSV"
  skip_header        = 1
  field_optionally_enclosed_by = "\""
  error_on_column_count_mismatch = false
}
