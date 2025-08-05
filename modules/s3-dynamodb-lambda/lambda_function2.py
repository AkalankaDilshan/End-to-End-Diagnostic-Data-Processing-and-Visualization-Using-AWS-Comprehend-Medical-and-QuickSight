import json
import boto3 
import pandas as pd 
import io 
import uuid 
from datetime import datetime
import os 
from urllib.parse import unquote_plus

s3_client = boto3.client('s3')
dynamodb = boto3.resource('dynamodb')

DYNAMODB_TABLE_NAME = os.environ['DYNAMODB_TABLE_NAME']
ALLOWED_EXTENSIONS = os.environ.get('ALLOWED_EXTENSIONS', 'csv,xlsx,xls'.split(','))

def lambda_handler(event, context): 
     try:
          for record in event['Records']:
               bucket_name = record['s3']['bucket']['name']
               object_key = unquote_plus(record['s3']['object']['key'])
               
               print(f"Processing file: {object_key} from bucket: {bucket_name}")
               
               # check file match or not 
               file_extension = object_key.split('.')[-1].lower
               if file_extension not in ALLOWED_EXTENSIONS:
                    print(f"Skipping file {object_key} - unsupported extension: {file_extension}")
                    continue
               
               response = s3_client.get_object(Bucket=bucket_name, Key=object_key)
               file_content = response['Body'].read()
               
               if file_extension == 'csv':
                df = pd.read_csv(io.BytesIO(file_content))
               elif file_extension in ['xlsx', 'xls']:
                df = pd.read_excel(io.BytesIO(file_content))
               else:
                print(f"Unsupported file type: {file_extension}")
                continue
           
                process_dataframe(df, object_key)
          
          return {
               'statusCode' : 200,
               'body': json.dump('File processed successfully')
          }
     except Exception as e:
          print(f"Error processing file: {str(e)}")
          return {
               'statusCode': 500,
               'body': json.dump(f"Error processing file: {str(e)}")
          }

def process_medical_reports(df, source_file):
    table = dynamodb.Table(DYNAMODB_TABLE_NAME)

def process_dataframe(df, source_file):
     
     table = dynamodb.Table(DYNAMODB_TABLE_NAME)
     current_timestamp = datetime.utcnow().isoformat()
     
     with table.batch_writer() as batch:
        for index, row in df.iterrows():
            try:
                #unique ID 
                record_id = str(uuid.uuid4())
                
                row_dict = row.to_dict()
                cleaned_row = {}
                
                for key, value in row_dict.items():
                    clean_key = str(key).replace(' ', '_').replace('-', '_')
                    
                    
                    if pd.isna(value):
                        cleaned_row[clean_key] = None
                    elif isinstance(value, (int, float)):
                        if pd.isna(value):
                            cleaned_row[clean_key] = None
                        else:
                            cleaned_row[clean_key] = float(value) if '.' in str(value) else int(value)
                    else:
                        cleaned_row[clean_key] = str(value)
                
                # Create DynamoDB record
                item = {
                    'id': record_id,
                    'timestamp': current_timestamp,
                    'source_file': source_file,
                    'row_index': index,
                    'data': cleaned_row
                }
                
                batch.put_item(Item=item)
                
            except Exception as e:
                print(f"Error processing row {index}: {str(e)}")
                continue
    
print(f"Successfully processed {len(df)} rows from {source_file}")