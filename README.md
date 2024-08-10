# Formula One Data Ingestion Project
## Overview
This project automates the ingestion, processing, and normalization of Formula One race data from the Open F1 API (api.openf1.org). The data is extracted from the API using an AWS Lambda function, stored in an S3 bucket, and then ingested into Snowflake for further normalization and storage in a final database.

API Link - https://openf1.org/

> [!IMPORTANT]
> The tools and architectural decisions made in this project were chosen to prioritize learning new technologies and building on existing skills rather than optimizing for efficiency.

 ## Services & Tools
1. AWS
   - S3
   - Lambda
   - IAM
     
2. Snowflake
   - Stage
   - Snowpipe
   - Storage Integration
   - Stream
   - Task
