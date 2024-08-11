# Create Staging Database
resource "snowflake_database" "formulaone_staging" {
  name    = "formulaone_staging"
  comment = "Database for staging race and driver data"
}

# Create Staging Schema
resource "snowflake_schema" "staging_processengine" {
  name     = "processengine"
  database = snowflake_database.formulaone_staging.name
  comment  = "Schema for staging data"
}

# Create Table in Staging Schema
resource "snowflake_table" "staging_racedetails" {
  name     = "racedetails"
  database = snowflake_database.formulaone_staging.name
  schema   = snowflake_schema.staging_processengine.name

  column {
    name = "session_key"
    type = "STRING"
  }
  column {
    name = "session_name"
    type = "STRING"
  }
  column {
    name = "date_start"
    type = "STRING"
  }
  column {
    name = "date_end"
    type = "STRING"
  }
  column {
    name = "gmt_offset"
    type = "STRING"
  }
  column {
    name = "session_type"
    type = "STRING"
  }
  column {
    name = "meeting_key"
    type = "STRING"
  }
  column {
    name = "location"
    type = "STRING"
  }
  column {
    name = "country_key"
    type = "STRING"
  }
  column {
    name = "country_code"
    type = "STRING"
  }
  column {
    name = "country_name"
    type = "STRING"
  }
  column {
    name = "circuit_key"
    type = "STRING"
  }
  column {
    name = "circuit_short_name"
    type = "STRING"
  }
  column {
    name = "year"
    type = "STRING"
  }
  column {
    name = "broadcast_name"
    type = "STRING"
  }
  column {
    name = "first_name"
    type = "STRING"
  }
  column {
    name = "full_name"
    type = "STRING"
  }
  column {
    name = "headshot_url"
    type = "STRING"
  }
  column {
    name = "last_name"
    type = "STRING"
  }
  column {
    name = "driver_number"
    type = "STRING"
  }
  column {
    name = "team_colour"
    type = "STRING"
  }
  column {
    name = "team_name"
    type = "STRING"
  }
  column {
    name = "name_acronym"
    type = "STRING"
  }
  column {
    name = "drivers_country_code"
    type = "STRING"
  }
  column {
    name = "first_position"
    type = "STRING"
  }
  column {
    name = "first_position_date"
    type = "STRING"
  }
  column {
    name = "last_position"
    type = "STRING"
  }
  column {
    name = "last_position_date"
    type = "STRING"
  }
}
