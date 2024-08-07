import boto3

def bump_ec2_cpu(instance_id, new_instance_type, region):

    ec2 = boto3.client('ec2', region_name=region)

    # Stop the instance
    print(f"Stopping instance {instance_id}...")
    ec2.stop_instances(InstanceIds=[instance_id])

    # Wait for the instance to stop
    waiter = ec2.get_waiter('instance_stopped')
    waiter.wait(InstanceIds=[instance_id])
    print(f"Instance {instance_id} stopped.")

    # Change the instance type
    print(f"Changing instance type to {new_instance_type}...")
    ec2.modify_instance_attribute(InstanceId=instance_id, Attribute='instanceType', Value=new_instance_type)
    print(f"Instance type changed to {new_instance_type}.")

    # Start the instance
    print(f"Starting instance {instance_id}...")
    ec2.start_instances(InstanceIds=[instance_id])

    # Wait for the instance to start
    waiter = ec2.get_waiter('instance_running')
    waiter.wait(InstanceIds=[instance_id])
    print(f"Instance {instance_id} is running with new instance type {new_instance_type}.")

def read_instance_id(file_path):
    with open(file_path, 'r') as file:
        instance_id = file.read().strip()
    return instance_id

if __name__ == "__main__":
    file_path = 'instance_id.txt'
    instance_id = read_instance_id(file_path)
    print(f'The Instance ID is: {instance_id}')
    # Replace with your instance ID
    instance_id = instance_id
    # Replace with the new instance type you want to upgrade to
    new_instance_type = 't2.medium'
    # Optionally, replace with your desired region
    region = 'ap-south-1'

    bump_ec2_cpu(instance_id, new_instance_type, region)
    
