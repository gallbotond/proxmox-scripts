# Prompt user for folder path
$folderPath = Read-Host "Enter the full path to the folder containing the images"

# Validate the folder path
if (-Not (Test-Path $folderPath)) {
    Write-Host "The folder path does not exist. Please check and try again." -ForegroundColor Red
    exit
}

# Get all image files in the folder
$imageFiles = Get-ChildItem -Path $folderPath -File -Include *.jpg, *.jpeg, *.png, *.gif, *.bmp -Recurse

if ($imageFiles.Count -eq 0) {
    Write-Host "No image files found in the specified folder." -ForegroundColor Yellow
    exit
}

# List file names
Write-Host "File names:"
$imageFiles | ForEach-Object { Write-Host $_.Name }

# Get substring positions from user
$substringCorrect = $false
while (-Not $substringCorrect) {
    $startPos = [int](Read-Host "Enter the starting position of the substring")
    $endPos = [int](Read-Host "Enter the ending position of the substring")

    # List substrings
    $substrings = @{}
    $imageFiles | ForEach-Object {
        $substring = $_.Name.Substring($startPos, $endPos - $startPos + 1)
        $substrings[$_.Name] = $substring
        Write-Host "$($_.Name): $substring"
    }

    $confirmation = Read-Host "Are these substrings correct? (yes/no)"
    if ($confirmation -eq "yes") {
        $substringCorrect = $true
    }
}

# Get separation character positions from user
$separationCorrect = $false
while (-Not $separationCorrect) {
    $sepPos1 = [int](Read-Host "Enter the first position for the separation character")
    $sepPos2 = [int](Read-Host "Enter the second position for the separation character")

    # List substrings with separation character
    $substringsWithSep = @{}
    $substrings.GetEnumerator() | ForEach-Object {
        $substring = $_.Value.Insert($sepPos1, "-").Insert($sepPos2 + 1, "-")
        $substringsWithSep[$_.Key] = $substring
        Write-Host "$($_.Key): $substring"
    }

    $confirmation = Read-Host "Are these substrings with separation character correct? (yes/no)"
    if ($confirmation -eq "yes") {
        $separationCorrect = $true
    }
}

# Attempt to convert substrings to dates and update file creation dates
$substringsWithSep.GetEnumerator() | ForEach-Object {
    $fileName = $_.Key
    $dateString = $_.Value
    try {
        $targetDateTime = [datetime]::ParseExact($dateString, "yyyy-MM-dd", [System.Globalization.CultureInfo]::InvariantCulture)
        $(Get-Item "$folderPath\$fileName").CreationTime = $targetDateTime
        $(Get-Item "$folderPath\$fileName").LastWriteTime = $targetDateTime
        $(Get-Item "$folderPath\$fileName").LastAccessTime = $targetDateTime
        Write-Host "Updated creation date for file: $fileName" -ForegroundColor Green
    } catch {
        Write-Host "Failed to update file: $fileName. Error: $_" -ForegroundColor Red
    }
}

Write-Host "All files have been processed." -ForegroundColor Cyan