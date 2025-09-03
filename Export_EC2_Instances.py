#!/usr/bin/env python3

"""
Author : Shamlin
Date   : 3rd Sep 2025
Version: V1
This script reports the AWS EC2 usage and exports instance details to a CSV file.
"""

import boto3
import csv

# Create EC2 client
ec2 = boto3.client('ec2')

# Describe instances
response = ec2.describe_instances()

# Open CSV file for writing
with open('ec2-instances.csv', mode='w', newline='') as file:
    writer = csv.writer(file)

    # Write header row
    writer.writerow([
        'InstanceId', 'Name', 'InstanceType', 'State',
        'AvailabilityZone', 'PrivateIP', 'PublicIP'
    ])

    # Loop through reservations and instances
    for reservation in response['Reservations']:
        for instance in reservation['Instances']:
            instance_id = instance.get('InstanceId', '')
            instance_type = instance.get('InstanceType', '')
            state = instance.get('State', {}).get('Name', '')
            az = instance.get('Placement', {}).get('AvailabilityZone', '')
            private_ip = instance.get('PrivateIpAddress', '')
            public_ip = instance.get('PublicIpAddress', '')

            # Extract "Name" tag if it exists
            name = ''
            for tag in instance.get('Tags', []):
                if tag['Key'] == 'Name':
                    name = tag['Value']
                    break

            # Write to CSV
            writer.writerow([
                instance_id, name, instance_type, state,
                az, private_ip, public_ip
            ])

print("Export complete: ec2-instances.csv")
