$Path = "C:\" # Root directory to start search
$MaxLength = 260 # Maximum path length limit
$OutputFile = "C:\long_paths.txt" # Output file for results

# Ensure the output file is clear
if (Test-Path $OutputFile) { Remove-Item $OutputFile }

# Attempt to list all items, focusing on error handling
Get-ChildItem -Path $Path -Recurse -ErrorAction SilentlyContinue -ErrorVariable Err | Where-Object { $_.FullName.Length -gt $MaxLength } | ForEach-Object {
    Add-Content -Path $OutputFile -Value $_.FullName
}

# Optionally, log errors to a separate file for review
$Err | ForEach-Object { $_.Exception.Message | Out-File "C:\errors_log.txt" -Append }

Write-Host "Results saved to $OutputFile. Errors (if any) logged to C:\errors_log.txt"