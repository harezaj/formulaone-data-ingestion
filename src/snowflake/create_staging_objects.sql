-- Create the staging database and schema for race and driver data
CREATE DATABASE FORMULAONE_STAGING COMMENT = 'Database for staging race and driver data';

CREATE SCHEMA FORMULAONE_STAGING.PROCESSENGINE COMMENT = 'Schema for staging data';

-- Create table to store race details in the staging schema
CREATE OR REPLACE TABLE FORMULAONE_STAGING.PROCESSENGINE.RACEDETAILS (
    session_key STRING,
    session_name STRING,
    date_start STRING,
    date_end STRING,
    gmt_offset STRING,
    session_type STRING,
    meeting_key STRING,
    location STRING,
    country_key STRING,
    country_code STRING,
    country_name STRING,
    circuit_key STRING,
    circuit_short_name STRING,
    year STRING,
    broadcast_name STRING,
    first_name STRING,
    full_name STRING,
    headshot_url STRING,
    last_name STRING,
    driver_number STRING,
    team_colour STRING,
    team_name STRING,
    name_acronym STRING,
    drivers_country_code STRING,
    first_position STRING,
    first_position_date STRING,
    last_position STRING,
    last_position_date STRING
);

-- Describe the table to ensure it was created correctly
DESC TABLE FORMULAONE_STAGING.PROCESSENGINE.RACEDETAILS;
