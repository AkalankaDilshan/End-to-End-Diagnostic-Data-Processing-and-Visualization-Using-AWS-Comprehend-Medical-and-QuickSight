import os
import json
import base64
import boto3
from datetime import datetime

s3 = boto3.client('s3')

def lambda_handler(event, context):
    try:
        # Parse the incoming event
        body = json.loads(event['body'])
        file_content = base64.b64decode(body['file'])
       
        # Get filename and content-type from body instead of headers
        filename = body.get('filename') or f"upload_{datetime.now().strftime('%Y%m%d%H%M%S')}"
        content_type = body.get('contentType', 'application/octet-stream')
       
        # Determine file extension based on content type or filename
        if content_type:
            if 'csv' in content_type.lower():
                extension = '.csv'
            elif 'excel' in content_type.lower() or 'xls' in content_type.lower():
                extension = '.xlsx' if 'openxml' in content_type.lower() else '.xls'
            else:
                extension = os.path.splitext(filename)[1] or '.bin'
        else:
            extension = os.path.splitext(filename)[1] or '.bin'
       
        # Clean filename and add extension if not present
        clean_filename = os.path.basename(filename).replace(' ', '_')
        if not clean_filename.lower().endswith(('.csv', '.xls', '.xlsx')):
            clean_filename += extension
       
        # Upload to S3
        s3_key = f"uploads/{clean_filename}"
        s3.put_object(
            Bucket=os.environ['S3_BUCKET'],
            Key=s3_key,
            Body=file_content,
            ContentType=content_type
        )
       
        return {
            'statusCode': 200,
            'headers': {
                'Access-Control-Allow-Origin': 'https://main.d2n7wx66fj019p.amplifyapp.com',
                'Access-Control-Allow-Credentials': 'true',
                'Access-Control-Allow-Headers': 'Content-Type,Authorization',
                'Access-Control-Allow-Methods': 'OPTIONS,POST,GET'
            },
            'body': json.dumps({
                'message': 'File uploaded successfully',
                'filename': clean_filename,
                's3_key': s3_key
            })
        }
       
    except Exception as e:
        print(f"Error: {str(e)}")
        return {
            'statusCode': 500,
            'headers': {
                'Access-Control-Allow-Origin': '*',
                'Access-Control-Allow-Credentials': True,
                'Access-Control-Allow-Headers': 'Content-Type,Authorization'
            },
            'body': json.dumps({
                'error': 'Failed to upload file',
                'details': str(e)
            })
        }