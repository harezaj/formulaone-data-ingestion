# Must run SQL commands directly in Snowflake to activate Tasks


resource "snowflake_task" "merge_racedetails_task" {
  name              = "merge_racedetails_task"
  database          = "formulaone_staging"  
  schema            = "processengine"             
  warehouse         = "COMPUTE_WH"
  schedule          = "USING CRON 0 17 * * MON UTC" # Noon EST every Monday
  sql_statement     = <<EOF
BEGIN
  -- Update/Insert into drivers table
  MERGE INTO formulaone_final.drivers.driver_information AS target
  USING (
      SELECT DISTINCT
          first_name, last_name, full_name, headshot_url, driver_number, team_name, name_acronym, drivers_country_code AS country_code
      FROM formulaone_staging.processengine.racedetails
  ) AS source
  ON target.first_name = source.first_name AND target.last_name = source.last_name AND target.full_name = source.full_name
  WHEN MATCHED THEN
      UPDATE SET
          target.headshot_url = source.headshot_url,
          target.driver_number = source.driver_number,
          target.team_name = source.team_name,
          target.name_acronym = source.name_acronym,
          target.country_code = source.country_code,
          target.updated_at = CURRENT_TIMESTAMP
  WHEN NOT MATCHED THEN
      INSERT (first_name, last_name, full_name, headshot_url, driver_number, team_name, name_acronym, country_code, created_at, updated_at)
      VALUES (source.first_name, source.last_name, source.full_name, source.headshot_url, source.driver_number, source.team_name, source.name_acronym, source.country_code, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);

  -- Update/Insert into circuits table
  MERGE INTO formulaone_final.circuits.circuit_information AS target
  USING (
      SELECT DISTINCT
          location, country_code, country_name, circuit_short_name
      FROM formulaone_staging.processengine.racedetails
  ) AS source
  ON target.location = source.location AND target.circuit_short_name = source.circuit_short_name
  WHEN MATCHED THEN
      UPDATE SET
          target.country_code = source.country_code,
          target.country_name = source.country_name,
          target.updated_at = CURRENT_TIMESTAMP
  WHEN NOT MATCHED THEN
      INSERT (location, country_code, country_name, circuit_short_name, created_at, updated_at)
      VALUES (source.location, source.country_code, source.country_name, source.circuit_short_name, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);

  -- Insert into positions table
  INSERT INTO formulaone_final.positions.position_information (
      driver_id, circuit_id, session_name, session_date, year, broadcast_name, first_position, first_position_date, last_position, last_position_date, created_at, updated_at
  )
  SELECT
      d.driver_id, c.circuit_id, s.session_name, CAST(s.date_start AS DATE), s.year, s.broadcast_name, s.first_position, s.first_position_date, s.last_position, s.last_position_date, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
  FROM formulaone_staging.processengine.racedetails s
  JOIN formulaone_final.drivers.driver_information d ON s.first_name = d.first_name AND s.last_name = d.last_name AND s.driver_number = d.driver_number
  JOIN formulaone_final.circuits.circuit_information c ON s.location = c.location AND s.circuit_short_name = c.circuit_short_name;
END;
EOF
}

