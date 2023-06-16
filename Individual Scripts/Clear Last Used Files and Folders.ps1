# Output to the console
Write-Output "Clear last used files and folders"

# Define the target path
$targetPath = "$env:APPDATA\Microsoft\Windows\Recent\AutomaticDestinations\*.automaticDestinations-ms"

# Check if the target path exists
if (Test-Path -Path $targetPath) {
    # If the path exists, remove the item
    Remove-Item -Path $targetPath -Force -Recurse -ErrorAction SilentlyContinue
} else {
    # If the path does not exist, output a message
    Write-Output "The path $targetPath does not exist."
}
