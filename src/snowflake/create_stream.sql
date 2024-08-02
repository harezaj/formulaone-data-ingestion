-- Create a stream to capture changes in the race details table
CREATE OR REPLACE STREAM FORMULAONE_STAGING.PROCESSENGINE.RACEDETAILS_STREAM ON TABLE FORMULAONE_STAGING.PROCESSENGINE.RACEDETAILS;

-- Describe the stream to ensure it was created correctly
DESC STREAM FORMULAONE_STAGING.PROCESSENGINE.RACEDETAILS_STREAM; 
