import json
import requests


def lambda_handler(event, context):
    subnet_id = "aws_subnet.private_subnets.id"
    full_name = "YogeshBhagwat"
    email = "yogeshbhagwat477@gmail.com"
    
    API endpoint URL
    api_url = "https://ij92qpvpma.execute-api.eu-west-1.amazonaws.com/candidate-email_serverless_lambda_stage/data"
    
    
    Headers for the request
    headers = {'X-Siemens-Auth': 'test'}
    
    Payload data
    payload = {
        "subnet_id": aws_subnet.private_subnets.id,
        "name": YogeshBhagwat,
        "email": yogeshbhagwat477@gmail.com
    }
    
   
    payload_json = json.dumps(payload)
    
    try:
        response = requests.post(api_url, data=payload_json, headers=headers)
        
    
        if response.status_code == 200:
            return {
                'statusCode': 200,
                'body': 'Request successfully sent'
            }
        else:
            return {
                'statusCode': response.status_code,
                'body': 'Request failed'
            }
    
    except Exception as e:
        return {
            'statusCode': 500,
            'body': str(e)
        }
