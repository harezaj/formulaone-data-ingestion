-- Create the final database
CREATE DATABASE FORMULAONE_FINAL
COMMENT = 'Database for final race and driver data';

-- Create the schemas for final driver, circuit/track and positions data
CREATE SCHEMA FORMULAONE_FINAL.DRIVERS
COMMENT = 'Schema for final driver data';

CREATE SCHEMA FORMULAONE_FINAL.CIRCUITS
COMMENT = 'Schema for final circuit/track data';

CREATE SCHEMA FORMULAONE_FINAL.POSITIONS
COMMENT = 'Schema for positions during a race';

-- Create the final tables for driver, circuit/track and positions data
CREATE OR REPLACE TABLE FORMULAONE_FINAL.DRIVERS.DRIVER_INFORMATION (
    driver_id INTEGER AUTOINCREMENT PRIMARY KEY,
    first_name STRING,
    last_name STRING,
    full_name STRING,
    headshot_url STRING,
    driver_number STRING,
    team_name STRING,
    name_acronym STRING,
    country_code STRING,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE OR REPLACE TABLE FORMULAONE_FINAL.CIRCUITS.CIRCUIT_INFORMATION (
    circuit_id INTEGER AUTOINCREMENT PRIMARY KEY,
    location STRING,
    country_code STRING,
    country_name STRING,
    circuit_short_name STRING,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE OR REPLACE TABLE FORMULAONE_FINAL.POSITIONS.POSITION_INFORMATION (
    position_id INTEGER AUTOINCREMENT PRIMARY KEY,
    driver_id INTEGER,
    circuit_id INTEGER,
    session_name STRING,
    session_date DATE,
    year INTEGER,
    broadcast_name STRING,
    first_position INTEGER,
    first_position_date TIMESTAMP_TZ,
    last_position INTEGER,
    last_position_date TIMESTAMP_TZ,
    FOREIGN KEY (driver_id) REFERENCES FORMULAONE_FINAL.drivers.driver_information(driver_id),
    FOREIGN KEY (circuit_id) REFERENCES FORMULAONE_FINAL.circuits.circuit_information(circuit_id),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
