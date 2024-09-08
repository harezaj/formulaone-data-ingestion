# Formula One Data Ingestion Project

> [!WARNING]  
> This project, though short, provided valuable experience with new technologies and successfully achieved its goals. I'm now archiving it, but I plan to build upon it by using this data source in an upcoming, more complex project.

## Overview
This project automates the ingestion, processing, and normalization of Formula One race data from the Open F1 API (api.openf1.org). The data is extracted from the API using an AWS Lambda function, stored in an S3 bucket, and then ingested into Snowflake for further normalization and storage in a final database.

API Link - https://openf1.org/

> [!IMPORTANT]
> The tools and architectural decisions made in this project were chosen to prioritize learning new technologies and building on existing skills rather than optimizing for efficiency.

## Services & Tools

1. **AWS**
   - **S3:** Stores CSV files with data.
   - **Lambda:** Extracts data from API and uploads to S3.
   - **IAM:** Manages access to AWS resources.
   - **CloudWatch:** Monitors Lambda Function. Emails user if error occurs.

2. **Snowflake**
   - **Stage:** Defines and manages S3 Bucket.
   - **Snowpipe:** Loads data from S3 into Snowflake.
   - **Storage Integration:** Handles access to external storage.
   - **Stream:** Monitors changes in staging tables.
   - **Task:** Schedules and runs data processing jobs.

3. **Terraform**
   - **Infrastructure:** Terraform is used to manage all Snowflake resources, including stages, Snowpipe, streams, and file formats.
      - Allows a consistent and reproducible setup for Snowflake infrastructure.

## Brief Overview

1. **Data Extraction**
    - Data is extracted from the API using a Lambda Function.
    - **Three Different Data Sets Extracted:**
        1. **Session Data:** Contains Grand Prix (Race) information.
        2. **Driver Data:** Contains driver information.
        3. **Position Data:** Contains information on where the driver started and finished the Grand Prix.
    - **Data Normalization:**
        - The Session data is extracted first to obtain the Primary Key (PK).
        - The Session Key is then used to fetch related Driver and Position data.
        - These data sets are joined and normalized in Snowflake to maintain data integrity and consistency.

2. **Data Storage:**
    - The Lambda Function saves the normalized data as `.CSV` files into an S3 bucket.
    - **File Naming Convention:**
        - Each file name includes a date to indicate when the data was extracted.

3. **Data Ingestion and Processing:**
    - **Snowflake Task Scheduling:**
        - A Snowflake Task runs every Monday to check the Snowflake Stage for new data.
    - **Data Processing:**
        - If new data is detected, Snowpipe automatically ingests the data from the S3 bucket into a Snowflake staging table.
        - A subsequent Merge task processes the staging data by upserting it into the final tables, ensuring the data is up-to-date and consistent.

4. **Additional Details:**
    - **Schema Design:**
        - Staging schemas: `formulaone_staging.drivers`, `formulaone_staging.races`, `formulaone_staging.tracks`.
        - Final schemas: `formulaone_final.drivers`, `formulaone_final.races`, `formulaone_final.tracks`.
    - **Storage Integration:**
        - A single storage integration (`s3_formulaone`) is used to manage access to S3 buckets for multiple external stages.

5. **Error Handling & Monitoring:**
    - **Error Handling:**
        - Error handling is implemented in the Lambda Function code to manage API failures or data extraction issues.
    - **Monitoring:**
        - CloudWatch is set up to email the user if an error occurs in the Lambda function.

## Future Improvements / Nice to Haves
  -  [ ] **Implement Terraform:**
        - [x] Snowflake Objects
        - [ ] AWS Objects
  - [ ] **Data Visualization:** Tableau, Looker, or Power BI

  *Note: This project was for learning purposes, and these tools are nice-to-haves but are unlikely to be implemented.*
