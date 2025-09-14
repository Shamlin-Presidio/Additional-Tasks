$instances = aws ec2 describe-instances `
  --query "Reservations[*].Instances[*].{
      InstanceId: InstanceId,
      Name: Tags[?Key=='Name']|[0].Value,
      InstanceType: InstanceType,
      State: State.Name,
      AvailabilityZone: Placement.AvailabilityZone,
      PrivateIP: PrivateIpAddress,
      PublicIP: PublicIpAddress
    }" `
  --output json | ConvertFrom-Json

# Flatten and export to CSV
$flatList = foreach ($reservation in $instances) {
    foreach ($instance in $reservation) {
        [PSCustomObject]@{
            InstanceId        = $instance.InstanceId
            Name              = $instance.Name
            InstanceType      = $instance.InstanceType
            State             = $instance.State
            AvailabilityZone  = $instance.AvailabilityZone
            PrivateIP         = $instance.PrivateIP
            PublicIP          = $instance.PublicIP
        }
    }
}

$flatList | Export-Csv -Path "ec2-instances.csv" -NoTypeInformation

Write-Host "Exported instances to ec2-instances.csv"
