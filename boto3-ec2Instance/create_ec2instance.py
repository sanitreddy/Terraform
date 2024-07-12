import boto3

# Initialize a session using Amazon EC2
ec2 = boto3.resource('ec2')

# Specify the details of the instance
instance_details = {
    'ImageId': 'ami-0ec0e125bb6c6e8ec',  # Replace with a valid AMI ID
    'InstanceType': 't2.micro',
    'KeyName': 'DemoKeyPair',  # Replace with your key pair name
    'MinCount': 1,
    'MaxCount': 1,
    'SecurityGroupIds': ['sg-03c8d1cf7a34239c5'],  # Replace with your security group ID
    'SubnetId': 'subnet-0006ee72cd1a7e623',  # Replace with your subnet ID
    'TagSpecifications': [{
        'ResourceType': 'instance',
        'Tags': [{'Key': 'Name', 'Value': 'MyInstance'}]
    }]
}

# Create the instance
try:
    instances = ec2.create_instances(**instance_details)
    instance_id = instances[0].id
    print(f'Instance created with ID: {instance_id}')

    # Wait for the instance to enter the running state
    ec2_client = boto3.client('ec2')
    waiter = ec2_client.get_waiter('instance_running')
    waiter.wait(InstanceIds=[instance_id])
    print(f'Instance {instance_id} is now running')

except Exception as e:
    print(f'Error creating instance: {e}')
