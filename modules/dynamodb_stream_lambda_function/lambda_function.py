import json
import boto3

def lambda_handler(event, context):
    sns = boto3.client('sns')
    account_id = context.invoked_function_arn.split(":")[4]
    region = context.invoked_function_arn.split(":")[3]
    
    sns_topic_name = "Add_new_medical_record"
    processed_records = []
    
    for record in event['Records']:
        # Only process INSERT events (new items)
        if record['eventName'] == 'INSERT':
            new_image = record['dynamodb']['NewImage']
            report_id = new_image['Report_ID']['S']
            
            # Publish the message to SNS
            response = sns.publish(
                TopicArn=f'arn:aws:sns:{region}:{account_id}:{sns_topic_name}',
                Message=f'New Medical Report {report_id} has been added',
                Subject='New Medical Report Added to Database'
            )
            
            processed_records.append({
                'report_id': report_id,
                'eventName': record['eventName'],
                'sns_response': response
            })
    
    return {
        "statusCode": 200,
        "body": json.dumps({
            "message": f"Processed {len(processed_records)} new medical records",
            "processed_records": processed_records
        })
    }