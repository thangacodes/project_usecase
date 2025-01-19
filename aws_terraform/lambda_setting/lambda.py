import json
import boto3

def lambda_handler(event, context):
    # Pretty print the event
    print("Event:", json.dumps(event, indent=4))

    # Create an S3 client
    s3 = boto3.client('s3')

    # Specify the S3 bucket and object (json_data.json)
    bucket_name = 'gitops-demo-bucket-tf'
    file_key = 'json_data.json'

    try:
        # Retrieve the JSON file from S3
        response = s3.get_object(Bucket=bucket_name, Key=file_key)
        contents = response['Body'].read().decode('utf-8')

        # Parse the JSON data
        json_data = json.loads(contents)

        # Pretty print the loaded JSON data
        print("JSON Data:", json.dumps(json_data, indent=4))

        # Print specific fields
        print("Whoami:", json_data.get('whoami'))
        print("Work:", json_data.get('work'))
        print("My Family:", json_data.get('myfamily'))
        print("DevOps Skills:", json_data.get('devops'))

    except Exception as e:
        print(f"Error retrieving file from S3: {e}")
        raise e
