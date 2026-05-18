import json
import os
from datetime import datetime, timedelta
import boto3

ce_client = boto3.client('ce')

def lambda_handler(event, context):
    """
    Lambda function to fetch AWS daily costs from Cost Explorer
    Returns cost data that n8n workflow will process
    """
    
    # Get yesterday's date
    end_date = datetime.now().date()
    start_date = end_date - timedelta(days=1)
    
    # Fetch cost data
    try:
        response = ce_client.get_cost_and_usage(
            TimePeriod={
                'Start': start_date.strftime('%Y-%m-%d'),
                'End': end_date.strftime('%Y-%m-%d')
            },
            Granularity='DAILY',
            Metrics=['UnblendedCost'],
            GroupBy=[
                {
                    'Type': 'DIMENSION',
                    'Key': 'SERVICE'
                }
            ]
        )
        
        # Parse results
        total_cost = 0
        service_costs = []
        
        for result in response['ResultsByTime']:
            for group in result['Groups']:
                service = group['Keys'][0]
                cost = float(group['Metrics']['UnblendedCost']['Amount'])
                total_cost += cost
                
                if cost > 0.01:  # Only include services with meaningful cost
                    service_costs.append({
                        'service': service,
                        'cost': round(cost, 2)
                    })
        
        # Sort by cost descending
        service_costs.sort(key=lambda x: x['cost'], reverse=True)
        
        # Get threshold from environment
        threshold = float(os.environ.get('COST_THRESHOLD', 100))
        
        return {
            'statusCode': 200,
            'body': json.dumps({
                'date': start_date.strftime('%Y-%m-%d'),
                'total_cost': round(total_cost, 2),
                'threshold': threshold,
                'exceeds_threshold': total_cost > threshold,
                'top_services': service_costs[:5],  # Top 5 services
                'currency': 'USD'
            })
        }
        
    except Exception as e:
        return {
            'statusCode': 500,
            'body': json.dumps({
                'error': str(e)
            })
        }
