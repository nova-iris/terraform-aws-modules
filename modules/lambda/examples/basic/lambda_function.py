import json

def lambda_handler(event, context):
    """
    Simple Lambda function that returns a greeting.
    """
    name = event.get('name', 'World')
    
    response = {
        'statusCode': 200,
        'headers': {
            'Content-Type': 'application/json'
        },
        'body': json.dumps({
            'message': f'Hello, {name}!',
            'input': event
        })
    }
    
    return response