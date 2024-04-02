import base64
import json
import boto3
from datetime import datetime

s3_client = boto3.client('s3')
bucket_name = 'kp1-data-bucket'

def lambda_handler(event, context):
    records = event['Records']

    combined_data = []

    for record in records:
        data = record['kinesis']['data']
        decoded_data = base64.b64decode(data).decode('utf-8')

        # Convert the decoded data to a JSON object
        parsed_data = json.loads(decoded_data)

        combined_data.append(parsed_data)

        # Create a unique filename for each record based on the current timestamp
        filename = f"data-{datetime.utcnow().strftime('%Y-%m-%dT%H-%M-%S-%f')}.json"

        if len(combined_data) == 10:
        # Upload the JSON data to the S3 bucket
            s3_client.put_object(Bucket=bucket_name, Key=filename, Body=json.dumps(combined_data))

            combined_data = []
            
    # Upload any remaining data in the last partition
    if combined_data:
        filename = f"data-{datetime.utcnow().strftime('%Y-%m-%dT%H-%M-%S-%f')}.json"
        s3_client.put_object(Bucket=bucket_name, Key=filename, Body=json.dumps(combined_data))


    return {
        'statusCode': 200,
        'body': 'Success'
    }

