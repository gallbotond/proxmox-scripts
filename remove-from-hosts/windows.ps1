# Prompt user for the string to remove
$searchString = Read-Host "Enter the string to remove from the known_hosts file"

# Define the path to the known_hosts file
$knownHostsFilePath = "$env:USERPROFILE\.ssh\known_hosts"

# Check if the known_hosts file exists
if (-Not (Test-Path $knownHostsFilePath)) {
    Write-Host "The known_hosts file does not exist at $knownHostsFilePath." -ForegroundColor Red
    exit
}

# Read the known_hosts file
$knownHostsFileContent = Get-Content -Path $knownHostsFilePath

# Filter out lines that contain the search string
$filteredContent = $knownHostsFileContent | Where-Object { $_ -notmatch [regex]::Escape($searchString) }

# Write the filtered content back to the known_hosts file
$filteredContent | Set-Content -Path $knownHostsFilePath -Force

Write-Host "Lines containing '$searchString' have been removed from the known_hosts file."