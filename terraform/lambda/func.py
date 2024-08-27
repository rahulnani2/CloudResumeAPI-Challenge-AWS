import json
import boto3

# Initialize dynamoDB resource 
dynamodb = boto3.resource('dynamodb')

# Specify the DynamoDB Table to work with
table = dynamodb.Table('cloudresume-viewstable')

# Lambda function entry point
def lambda_handler(event, context):
    #Retrieve item from DynamoDB using primary Key
    response = table.get_item(
        Key={
        'id':'1'
    })
    views = response['Item']['views']
    views = views + 1
    print(views)
    response = table.put_item(Item={
        'id':'1',
        'views': views
    })
    return views
