-- Create storage integration for Snowflake to access S3 bucket
CREATE OR REPLACE STORAGE INTEGRATION FORMULAONE_SNOWPIPE_INTEGRATION
  TYPE = EXTERNAL_STAGE
  STORAGE_PROVIDER = S3
  ENABLED = TRUE
  STORAGE_AWS_ROLE_ARN = 'arn:aws:iam::<your-account-id>:role/<your-role-name>'
  STORAGE_ALLOWED_LOCATIONS = ('*');

-- Describe the storage integration to ensure it was created correctly
DESC INTEGRATION FORMULAONE_SNOWPIPE_INTEGRATION;

-- Create stage to load data from S3 bucket
CREATE OR REPLACE STAGE FORMULAONE_STAGING.PROCESSENGINE.RACEDETAILS_S3_STAGE
  URL = 's3://your-s3-bucket-name/racedetails/'
  STORAGE_INTEGRATION = formulaone_snowpipe_integration
  FILE_FORMAT = (TYPE = 'CSV' SKIP_HEADER = 1 FIELD_OPTIONALLY_ENCLOSED_BY = '"' ERROR_ON_COLUMN_COUNT_MISMATCH = FALSE);

-- List files available in the S3 bucket
LIST @FORMULAONE_STAGING.PROCESSENGINE.RACEDETAILS_S3_STAGE;