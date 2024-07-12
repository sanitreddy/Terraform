import json
import boto3
import os

dynamodb = boto3.resource('dynamodb')
table = dynamodb.Table(os.environ['DYNAMODB_TABLE'])

def lambda_handler(event, context):
    data = json.loads(event['body'])
    table.put_item(Item=data)
    return {
        'statusCode': 200,
        'body': json.dumps('Data inserted successfully')
    }
