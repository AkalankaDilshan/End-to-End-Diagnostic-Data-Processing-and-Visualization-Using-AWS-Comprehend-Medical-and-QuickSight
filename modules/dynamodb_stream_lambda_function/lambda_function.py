import json
import boto3
import os

sns_client = boto3.client('sns')

def lambda_handler(event, context):
    try:
        for record in event['Records']:
            if record['eventName'] == 'INSERT':
                new_item = record['dynamodb']['NewImage']
                
                #email msg
                message = f"""
                New item added to DynamoDB table: {json.dumps(new_item,indent=2)}
                
                Event details:
                - Event ID: {record['eventID']}
                - Event Source: {record['eventSource']}
                - AWS Region: {record['awsRegion']}
                """
                
                # send sns email
                response = sns_client.publish(
                    TopicArn=os.environ['SNS_TOPIC_ARN'],
                    Message=message,
                    Subject='New Item Added to DynamoDB'
                )
                
                print(f"Notification sent: {response['MessageId']}")
        
        return{
            'statusCode': 200,
            'body': json.dump('Processe DynamoDB stream records successfully')
        }
        
    except Exception as e:
        print(f"Error processing DynamoDB stream: {str(e)}")
        raise e
