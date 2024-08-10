import json
import boto3
import urllib3
import logging
from datetime import datetime
from collections import defaultdict

# Initialize logging
logger = logging.getLogger()
logger.setLevel(logging.INFO)

# S3 client to interact with the S3 service
s3_client = boto3.client("s3")

# S3 bucket name
s3_bucket = "your-s3-bucket-name"

# Headers required for the API request
headers = {
    'user-agent': 'YourUserAgent'
}

# Function to retrieve data from an API
def get_api_data(url):
    http = urllib3.PoolManager()
    try:
        # Make the API request
        response = http.request("GET", url, retries=urllib3.util.Retry(3), headers=headers)
        logger.info(f"Fetched data from {url}")
        return json.loads(response.data.decode('utf-8'))
    except urllib3.exceptions.MaxRetryError as e:
        logger.error(f"MaxRetryError while fetching data from {url}: {e}")
        return []
    except Exception as e:
        logger.error(f"Error fetching data from {url}: {e}")
        return []

# Function to rename country_code to drivers_country_code in driver data
def rename_country_code(drivers):
    for driver in drivers:
        if 'country_code' in driver:
            driver['drivers_country_code'] = driver.pop('country_code')
    logger.info("Renamed 'country_code' to 'drivers_country_code' in driver data.")
    return drivers

# Function to join datasets without using pandas
def join_datasets(drivers, session, positions):
    session_key = session['session_key']
    meeting_key = session['meeting_key']
    
    # Create dictionaries for quick lookup
    drivers_dict = {(d['driver_number'], d['session_key'], d['meeting_key']): d for d in drivers}
    positions_dict = defaultdict(list)
    for p in positions:
        positions_dict[(p['driver_number'], p['session_key'], p['meeting_key'])].append(p)
    
    combined_data = []
    
    # Join session to driver without driver_number
    matching_drivers = [d for d in drivers if d['session_key'] == session_key and d['meeting_key'] == meeting_key]
    
    for driver in matching_drivers:
        driver_number = driver['driver_number']
        key = (driver_number, session_key, meeting_key)
        position_list = positions_dict.get(key, [])
        
        if position_list:
            position_list.sort(key=lambda x: x.get('date', ''))
            first_position = position_list[0]
            last_position = position_list[-1]
            
            combined_record = {**session, **driver}
            combined_record.update({
                "first_position": first_position.get("position", ""),
                "first_position_date": first_position.get("date", ""),
                "last_position": last_position.get("position", ""),
                "last_position_date": last_position.get("date", "")
            })
            combined_data.append(combined_record)
    
    logger.info(f"Joined datasets into {len(combined_data)} combined records.")
    return combined_data

# Function to write data to a CSV string
def data_to_csv(data):
    if not data:
        return ""
    
    header = data[0].keys()
    rows = [header] + [d.values() for d in data]
    
    csv_data = "\n".join([",".join(map(str, row)) for row in rows])
    return csv_data

# Lambda handler function
def lambda_handler(event, context):
    try:
        # Get the current date and format it as YYYY-MM-DD
        current_date = datetime.now().strftime("%Y-%m-%d")
        logger.info(f"Processing data for date: {current_date}")

        # Intentionally trigger an exception for testing
        # raise RuntimeError("Intentional error for testing purposes.")
        
        # Get all session data from the API with the current date
        session_data = get_api_data("https://api.openf1.org/v1/sessions?date_start=2024-07-28")
        
        # Check for race sessions and get the session_key
        race_sessions = [s for s in session_data if s['session_type'] == 'Race']
        if not race_sessions:
            raise ValueError("No race sessions found for the current date.")
        
        # Use the first race session found
        race_session = race_sessions[0]
        session_key = race_session['session_key']
        logger.info(f"Using session_key: {session_key}")
        
        # Get driver and position data using the session_key
        driver_data = get_api_data(f"https://api.openf1.org/v1/drivers?session_key={session_key}")
        position_data = get_api_data(f"https://api.openf1.org/v1/position?session_key={session_key}")
        
        # Rename country_code to drivers_country_code in driver data
        driver_data = rename_country_code(driver_data)
        
        # Join the datasets
        combined_data = join_datasets(driver_data, race_session, position_data)
        
        # Convert data to CSV format
        csv_data = data_to_csv(combined_data)
        
        # Check if CSV data is empty
        if not csv_data.strip():
            raise ValueError("CSV data is empty.")
        
        # Define the S3 key (file name in the bucket) with the date
        s3_key = f"racedetails/racedetails_{current_date.replace('-', '')}.csv"
        
        # Upload the CSV data to S3
        s3_client.put_object(Bucket=s3_bucket, Key=s3_key, Body=csv_data)
        logger.info(f"Data successfully uploaded to S3 with key: {s3_key}")
        
        return {
            'statusCode': 200,
            'body': json.dumps('Data successfully uploaded to S3')
        }
    except Exception as e:
        logger.error(f"Error: {e}")
        return {
            'statusCode': 500,
            'body': json.dumps('Error uploading data to S3')
        }

# Test the handler
if __name__ == "__main__":
    print(lambda_handler({}, {}))
