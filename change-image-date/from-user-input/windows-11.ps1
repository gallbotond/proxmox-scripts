# Prompt user for folder path and target date
$folderPath = Read-Host "Enter the full path to the folder containing the images"
$targetDate = Read-Host "Enter the target creation date (e.g., YYYY-MM-DD HH:MM:SS)"

# Validate the folder path
if (-Not (Test-Path $folderPath)) {
    Write-Host "The folder path does not exist. Please check and try again." -ForegroundColor Red
    exit
}

# Validate the target date
$targetDateTime = $null
try {
    $targetDateTime = [datetime]::ParseExact($targetDate, "yyyy-MM-dd HH:mm:ss", [System.Globalization.CultureInfo]::InvariantCulture)
} catch {
    Write-Host "The date format is invalid. Please use the format YYYY-MM-DD HH:MM:SS." -ForegroundColor Red
    exit
}

# Get all image files in the folder
$imageFiles = Get-ChildItem -Path $folderPath -File -Include *.jpg, *.jpeg, *.png, *.gif, *.bmp -Recurse

if ($imageFiles.Count -eq 0) {
    Write-Host "No image files found in the specified folder." -ForegroundColor Yellow
    exit
}

# Set the creation date for each image
foreach ($file in $imageFiles) {
    try {
        # Update the creation, last write, and last access dates
        $(Get-Item $file.FullName).CreationTime = $targetDateTime
        $(Get-Item $file.FullName).LastWriteTime = $targetDateTime
        $(Get-Item $file.FullName).LastAccessTime = $targetDateTime

        Write-Host "Updated creation date for file: $($file.Name)" -ForegroundColor Green
    } catch {
        Write-Host "Failed to update file: $($file.Name). Error: $_" -ForegroundColor Red
    }
}

Write-Host "All files have been processed." -ForegroundColor Cyan