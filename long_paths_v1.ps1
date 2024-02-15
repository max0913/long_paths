$Path = "C:\" # Specify the root directory to start the search
$MaxLength = 260 # Define the maximum path length limit
$OutputFile = "C:\long_paths.txt" # Output file to store results

# Custom function to handle long paths
function Get-FilesWithLongPath {
    param (
        [string]$Path,
        [int]$MaxLength
    )
    $items = New-Object System.Collections.ArrayList
    # Enumerate all files
    [System.IO.Directory]::EnumerateFiles($Path, "*", [System.IO.SearchOption]::AllDirectories) | ForEach-Object {
        try {
            if ($_ -and $_.Length -gt $MaxLength) {
                $null = $items.Add($_)
            }
        } catch {
            Write-Warning "Error accessing: $_"
        }
    }
    # Enumerate all directories
    [System.IO.Directory]::EnumerateDirectories($Path, "*", [System.IO.SearchOption]::AllDirectories) | ForEach-Object {
        try {
            if ($_ -and $_.Length -gt $MaxLength) {
                $null = $items.Add($_)
            }
        } catch {
            Write-Warning "Error accessing: $_"
        }
    }
    return $items
}

# Call the function and output results
Get-FilesWithLongPath -Path $Path -MaxLength $MaxLength | Out-File -FilePath $OutputFile

Write-Host "Results saved to $OutputFile"