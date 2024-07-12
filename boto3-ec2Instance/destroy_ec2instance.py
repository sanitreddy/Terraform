import boto3

# Initialize a session using Amazon EC2
ec2_client = boto3.client('ec2')

# Specify the instance ID to terminate
instance_id = 'i-0659c9d8fafbb076d'  # Replace with your instance ID

# Terminate the instance
try:
    response = ec2_client.terminate_instances(InstanceIds=[instance_id])
    print(f'Termination initiated for instance: {instance_id}')

    # Wait for the instance to be terminated
    waiter = ec2_client.get_waiter('instance_terminated')
    waiter.wait(InstanceIds=[instance_id])
    print(f'Instance {instance_id} has been terminated')

except Exception as e:
    print(f'Error terminating instance: {e}')
