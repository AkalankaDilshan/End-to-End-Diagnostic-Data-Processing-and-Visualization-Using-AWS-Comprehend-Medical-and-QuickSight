import json
import boto3
import pandas as pd
import io
from datetime import datetime
import os
from urllib.parse import unquote_plus
import uuid

# Initialize AWS clients
s3_client = boto3.client('s3')
dynamodb = boto3.resource('dynamodb')

def lambda_handler(event, context):
    try:
        for record in event['Records']:
            bucket_name = record['s3']['bucket']['name']
            object_key = unquote_plus(record['s3']['object']['key'])
            
            print(f"Processing file: {object_key}")
            
            # Check file extension
            file_extension = object_key.split('.')[-1].lower()
            allowed_extensions = ['csv', 'xlsx', 'xls']
            if file_extension not in allowed_extensions:
                print(f"Skipping unsupported file type: {file_extension}")
                continue
            
            # Download and process file
            response = s3_client.get_object(Bucket=bucket_name, Key=object_key)
            file_content = response['Body'].read()
            
            if file_extension == 'csv':
                df = pd.read_csv(io.BytesIO(file_content))
            else:  # xlsx or xls
                df = pd.read_excel(io.BytesIO(file_content))
            
            process_medical_reports(df, object_key)
            
        return {'statusCode': 200, 'body': 'Processing completed'}
        
    except Exception as e:
        print(f"Error: {str(e)}")
        return {'statusCode': 500, 'body': f'Error: {str(e)}'}

def process_medical_reports(df, source_file):
    table = dynamodb.Table(os.environ['DYNAMODB_TABLE_NAME'])
    
    required_fields = ['Patient_Name', 'Test_Name']  # Minimum required fields
    column_mapping = {
        'Report_ID': {'field': 'Report_ID', 'type': 'S', 'required': False},
        'Patient_Name': {'field': 'Patient_Name', 'type': 'S', 'required': True},
        'Age': {'field': 'Age', 'type': 'N', 'required': False},
        'Gender': {'field': 'Gender', 'type': 'S', 'required': False},
        'Test_Name': {'field': 'Test_Name', 'type': 'S', 'required': True},
        'Result': {'field': 'Result', 'type': 'S', 'required': False},
        'Date': {'field': 'Date', 'type': 'S', 'required': False},
        'Doctor': {'field': 'Doctor', 'type': 'S', 'required': False},
        'Remarks': {'field': 'Remarks', 'type': 'S', 'required': False}
    }
    
    df.columns = df.columns.str.strip().str.replace(' ', '_')
    
    with table.batch_writer() as batch:
        for _, row in df.iterrows():
            try:
                item = {}
                
                # Generate Report_ID if not provided
                report_id = str(row.get('Report_ID', str(uuid.uuid4())))
                item['Report_ID'] = report_id
                
                # Process each field
                missing_required = False
                for config in column_mapping.values():
                    col = config['field']
                    if col in df.columns and not pd.isna(row[col]):
                        if config['type'] == 'N':
                            try:
                                item[col] = int(float(row[col]))
                            except:
                                item[col] = 0
                        else:
                            item[col] = str(row[col]).strip()
                    elif config['required']:
                        print(f"Missing required field {col} for Report_ID {report_id}")
                        missing_required = True
                        break
                
                if missing_required:
                    continue
                
                # Add metadata
                item['ProcessedAt'] = datetime.utcnow().isoformat()
                item['SourceFile'] = os.path.basename(source_file)
                
                batch.put_item(Item=item)
                print(f"Processed Report_ID: {report_id}")
                
            except Exception as e:
                print(f"Error processing row: {str(e)}")
                continue