$Path = "C:\" # Specify the root directory to start the search
$MaxLength = 260 # Define the maximum path length limit
$OutputFile = "C:\long_paths.txt" # Output file to store results

# Custom function to handle long paths and skip inaccessible paths
function Get-FilesWithLongPath {
    param (
        [string]$Path,
        [int]$MaxLength
    )
    $items = New-Object System.Collections.ArrayList
    # Attempt to enumerate all files, skipping inaccessible ones
    try {
        [System.IO.Directory]::EnumerateFiles($Path, "*", [System.IO.SearchOption]::AllDirectories) | ForEach-Object {
            try {
                if ($_.Length -gt $MaxLength) {
                    $null = $items.Add($_)
                }
            } catch {
                # Ignored
            }
        }
    } catch {
        Write-Warning "Unable to access some directories or files."
    }
    # Attempt to enumerate all directories, skipping inaccessible ones
    try {
        [System.IO.Directory]::EnumerateDirectories($Path, "*", [System.IO.SearchOption]::AllDirectories) | ForEach-Object {
            try {
                if ($_.Length -gt $MaxLength) {
                    $null = $items.Add($_)
                }
            } catch {
                # Ignored
            }
        }
    } catch {
        Write-Warning "Unable to access some directories or files."
    }
    return $items
}

# Call the function and output results
Get-FilesWithLongPath -Path $Path -MaxLength $MaxLength | Out-File -FilePath $OutputFile

Write-Host "Results saved to $OutputFile"