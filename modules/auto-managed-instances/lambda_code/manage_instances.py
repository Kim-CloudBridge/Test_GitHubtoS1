import boto3

def manage_instances(ec2, ec2_client, action, region_name, tag_value):
    instances = ec2.instances.filter(
        Filters=[
            {'Name': f'tag:{tag_value}', 'Values': ['true']},
            {'Name': 'instance-state-name', 'Values': ['pending', 'running', 'stopping', 'stopped']}
        ]
    )

    instance_ids = [instance.id for instance in instances]
    print(f"{action} for the following {tag_value} instances {instance_ids} in region: {region_name}")

    if action == 'start':
        print(f"Booting up {tag_value} instances")
        ec2_client.start_instances(InstanceIds=instance_ids)
    elif action == 'stop':
        print(f"Shutting down {tag_value} instances")
        ec2_client.stop_instances(InstanceIds=instance_ids)
    print(f"Process for {tag_value} instances finished")

def lambda_handler(event, context):
    action = event['action']
    tag = event['tag']
    region_name = event['region']
    ec2 = boto3.resource('ec2', region_name=region_name)
    ec2_client = boto3.client('ec2', region_name=region_name)

    manage_instances(ec2, ec2_client, action, region_name, tag)