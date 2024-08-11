# Define the Snowflake database
resource "snowflake_database" "formulaone_final" {
  name    = "formulaone_final"
  # comment = "Database for final race and driver data"
}

# Define the Snowflake schema for drivers
resource "snowflake_schema" "final_drivers" {
  name     = "drivers"
  database = snowflake_database.formulaone_final.name
  # comment  = "Schema for final driver data"
}

# Define the Snowflake schema for circuits
resource "snowflake_schema" "final_circuits" {
  name     = "circuits"
  database = snowflake_database.formulaone_final.name
  # comment  = "Schema for final circuit/track data"
}

# Define the Snowflake schema for positions
resource "snowflake_schema" "final_positions" {
  name     = "positions"
  database = snowflake_database.formulaone_final.name
  # comment  = "Schema for positions during a race"
}

# Define the Snowflake table for driver information
resource "snowflake_table" "final_driver_information" {
  database = snowflake_database.formulaone_final.name
  schema   = snowflake_schema.final_drivers.name
  name     = "driver_information"

  column {
    name = "driver_id"
    type = "INTEGER"
  }

  column {
    name = "first_name"
    type = "STRING"
  }

  column {
    name = "last_name"
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
    name = "driver_number"
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
    name = "country_code"
    type = "STRING"
  }

  column {
    name = "created_at"
    type = "TIMESTAMP"
  }

  column {
    name = "updated_at"
    type = "TIMESTAMP"
  }
}

# Define the Snowflake table for circuit information
resource "snowflake_table" "circuit_information" {
  database = snowflake_database.formulaone_final.name
  schema   = snowflake_schema.final_circuits.name
  name     = "circuit_information"

  column {
    name = "circuit_id"
    type = "INTEGER"
  }

  column {
    name = "location"
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
    name = "circuit_short_name"
    type = "STRING"
  }

  column {
    name = "created_at"
    type = "TIMESTAMP"
  }

  column {
    name = "updated_at"
    type = "TIMESTAMP"
  }
}

# Define the Snowflake table for position information
resource "snowflake_table" "position_information" {
  database = snowflake_database.formulaone_final.name
  schema   = snowflake_schema.final_positions.name
  name     = "position_information"

  column {
    name = "position_id"
    type = "INTEGER"
  }

  column {
    name = "driver_id"
    type = "INTEGER"
  }

  column {
    name = "circuit_id"
    type = "INTEGER"
  }

  column {
    name = "session_name"
    type = "STRING"
  }

  column {
    name = "session_date"
    type = "DATE"
  }

  column {
    name = "year"
    type = "INTEGER"
  }

  column {
    name = "broadcast_name"
    type = "STRING"
  }

  column {
    name = "first_position"
    type = "INTEGER"
  }

  column {
    name = "first_position_date"
    type = "TIMESTAMP_TZ"
  }

  column {
    name = "last_position"
    type = "INTEGER"
  }

  column {
    name = "last_position_date"
    type = "TIMESTAMP_TZ"
  }

  column {
    name = "created_at"
    type = "TIMESTAMP"
  }

  column {
    name = "updated_at"
    type = "TIMESTAMP"
  }
}

# Define primary key constraint for driver_information
resource "snowflake_table_constraint" "primary_key_driver_information" {
  name     = "pk_driver_information"
  type     = "PRIMARY KEY"
  table_id = snowflake_table.final_driver_information.qualified_name
  columns  = ["driver_id"]
  # comment  = "Primary key for driver_information table"
}

# Define foreign key constraint from position_information to driver_information
resource "snowflake_table_constraint" "foreign_key_position_driver" {
  name     = "fk_position_driver"
  type     = "FOREIGN KEY"
  table_id = snowflake_table.position_information.qualified_name
  columns  = ["driver_id"]
  
  foreign_key_properties {
    references {
      table_id = snowflake_table.final_driver_information.qualified_name
      columns  = ["driver_id"]
    }
  }
  enforced   = true
  deferrable = false
  initially  = "IMMEDIATE"
  # comment    = "Foreign key from position_information to driver_information"
}

# Define foreign key constraint from position_information to circuit_information
resource "snowflake_table_constraint" "foreign_key_position_circuit" {
  name     = "fk_position_circuit"
  type     = "FOREIGN KEY"
  table_id = snowflake_table.position_information.qualified_name
  columns  = ["circuit_id"]
  
  foreign_key_properties {
    references {
      table_id = snowflake_table.circuit_information.qualified_name
      columns  = ["circuit_id"]
    }
  }
  enforced   = true
  deferrable = false
  initially  = "IMMEDIATE"
  # comment    = "Foreign key from position_information to circuit_information"
}
