# Prompt user for folder path
$folderPath = Read-Host "Enter the full path to the folder containing the images"

# Validate the folder path
if (-Not (Test-Path $folderPath)) {
    Write-Host "The folder path does not exist. Please check and try again." -ForegroundColor Red
    exit
}

# Get all image files in the folder
$imageFiles = Get-ChildItem -Path $folderPath -File -Include *.jpg, *.jpeg, *.png, *.gif, *.bmp, *.heic, *.mp4, *.mov, *.avi, *.mkv, *.wmv, *.flv, *.webm -Recurse

if ($imageFiles.Count -eq 0) {
    Write-Host "No image files found in the specified folder." -ForegroundColor Yellow
    exit
}

# Set the creation date for each image based on the updated date
foreach ($file in $imageFiles) {
    try {
        $updatedDate = $(Get-Item $file.FullName).LastWriteTime
        $(Get-Item $file.FullName).CreationTime = $updatedDate

        Write-Host "Updated creation date for file: $($file.Name)" -ForegroundColor Green
    } catch {
        Write-Host "Failed to update file: $($file.Name). Error: $_" -ForegroundColor Red
    }
}

Write-Host "All files have been processed." -ForegroundColor Cyan