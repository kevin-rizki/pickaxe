# Get the current user's home directory
$homeDir = [Environment]::GetFolderPath('UserProfile')

# Create a new directory for the Node Exporter ZIP file
$installDir = Join-Path $homeDir 'Node Exporter'
New-Item -ItemType Directory -Path $installDir

# Download the latest version of Node Exporter using System.Net.WebClient
$client = new-object System.Net.WebClient
$client.DownloadFile('https://github.com/prometheus/node_exporter/releases/latest/download/node_exporter-windows-amd64.zip', "$installDir\node_exporter.zip")

# Unzip the downloaded package
Expand-Archive -Path "$installDir\node_exporter.zip" -DestinationPath "$installDir\"

# Create a new Windows service for Node Exporter
New-Service -Name 'node_exporter' -BinaryPathName "$installDir\node_exporter.exe" -DisplayName 'Node Exporter' -Description 'Prometheus exporter for machine metrics'

# Start the new service
Start-Service -Name 'node_exporter'

# Set the service to start automatically
Set-Service -Name 'node_exporter' -StartupType Automatic