import boto3
import csv
import logging

logger = logging.getLogger()
logger.setLevel(logging.INFO)

def lambda_handler(event, context):
    # S3 client
    s3_client = boto3.client('s3')

    # Get bucket and object key from the event
    bucket = event['Records'][0]['s3']['bucket']['name']
    key = event['Records'][0]['s3']['object']['key']

    # Read CSV file from S3
    response = s3_client.get_object(Bucket=bucket, Key=key)
    lines = response['Body'].read().decode('utf-8').split()
    reader = csv.reader(lines)

    for row in reader:
        logger.info(row)

    return {
        'statusCode': 200,
        'body': 'CSV file read successfully'
    }
