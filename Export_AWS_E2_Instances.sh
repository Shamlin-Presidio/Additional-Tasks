#!/bin/bash

####################################
# Author : Shamlin
# Date   : 3rd Sep 2025

# Version: V1
# This script reports the AWS usage
####################################
set -x


echo "Exporting EC2 instance details to ec2-instances.csv..."
aws ec2 describe-instances \
  --query "Reservations[*].Instances[*].{
    InstanceId: InstanceId,
    Name: Tags[?Key=='Name']|[0].Value,
    InstanceType: InstanceType,
    State: State.Name,
    AvailabilityZone: Placement.AvailabilityZone,
    PrivateIP: PrivateIpAddress,
    PublicIP: PublicIpAddress
  }" \
  --output text | tr '\t' ',' > ec2-instances.csv
