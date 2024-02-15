$Path = "C:\" # Specify the root directory to start the search
$MaxLength = 260 # Define the maximum path length limit
$OutputFile = "C:\long_paths.txt" # Output file to store results

# Clear the output file at the beginning
if (Test-Path $OutputFile) {
    Remove-Item $OutputFile
}

# Function to append to the output file
function Log-LongPath($path) {
    Add-Content -Path $OutputFile -Value $path
}

# Custom function to handle long paths and skip inaccessible paths, logging directly to file
function Get-FilesWithLongPath {
    param (
        [string]$Path,
        [int]$MaxLength
    )
    # Enumerate all files, logging paths longer than MaxLength directly to file
    try {
        [System.IO.Directory]::EnumerateFiles($Path, "*", [System.IO.SearchOption]::AllDirectories) | ForEach-Object {
            try {
                if ($_.Length -gt $MaxLength) {
                    Log-LongPath $_
                }
            } catch {
                # Log inaccessible file paths if necessary
                # Log-LongPath "Inaccessible file: $_"
            }
        }
    } catch {
        Write-Warning "Unable to access some directories or files."
    }
    # Enumerate all directories, logging paths longer than MaxLength directly to file
    try {
        [System.IO.Directory]::EnumerateDirectories($Path, "*", [System.IO.SearchOption]::AllDirectories) | ForEach-Object {
            try {
                if ($_.Length -gt $MaxLength) {
                    Log-LongPath $_
                }
            } catch {
                # Log inaccessible directory paths if necessary
                # Log-LongPath "Inaccessible directory: $_"
            }
        }
    } catch {
        Write-Warning "Unable to access some directories or files."
    }
}

# Execute the function
Get-FilesWithLongPath -Path $Path -MaxLength $MaxLength

Write-Host "Results saved to $OutputFile"