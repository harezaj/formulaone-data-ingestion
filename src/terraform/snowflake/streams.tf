resource "snowflake_stream" "racedetails_stream" {
  name      = "racedetails_stream"
  database  = "formulaone_staging"
  schema    = "processengine"
  on_table  = "formulaone_staging.processengine.racedetails"
  comment   = "Stream to capture changes in the race details table"
}
