# Variables
$pemFile = "Yogesh_J_S_2.pem"
$remoteUser = "ubuntu"
$remoteHost = "75.101.200.200"
$command = "whoami"

# PEM file permissionns
chmod 400 $pemFile

# SSH into the remote VM and get the username
$username = & ssh -i $pemFile "$remoteUser@$remoteHost" $command

# Output the username
Write-Host "Remote username: $username"
