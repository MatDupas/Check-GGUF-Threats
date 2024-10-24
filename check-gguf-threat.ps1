<#
.DESCRIPTION
This script reads a gguf model file, converts its content to a string using ASCII encoding,
and searches for specified patterns typically associated with Jinja2 SSTI. It prints warnings
with details if any of the specified strings are found.

.PARAMETER inputFile
Path to the binary file to be analyzed.

.PARAMETER searchStrings
Array of strings to search for in the file content. Defaults to ["__subclasses__", "__builtins__"].

.EXAMPLE
.\check-gguf-threat.ps1 model.gguf
Scans 'model.gguf' for default search strings.

.NOTES
Author: Mathieu Dupas
#>

param (
    [string]$inputFile,
    [array]$searchStrings = @("__subclasses__","__builtins__") # Typical functions used in jinja2 SSTI
)

if (-not $inputFile) {
    Write-Host "Usage: .\check-gguf-threat.ps1 <model.gguf> [searchString]"
    exit
}

# Read the binary file into a byte array and handle potential errors
try {
    $byteArray = [System.IO.File]::ReadAllBytes($inputFile)
} catch {
    Write-Host "Error reading file: $_"
    exit
}

# Convert the byte array to a string using ASCII encoding
$stringContent = [System.Text.Encoding]::ASCII.GetString($byteArray)

foreach ($searchString in $searchStrings) {
$result = $stringContent | Select-String -Pattern $searchString -AllMatches
if ($result) {
    Write-Host ("=" * 100)
    Write-Host -ForegroundColor cyan "[!] Warning ! Found potentially dangerous content '$searchString' string in the model file!"
    foreach ($match in $result.Matches) {
        $index = $match.Index
        Write-Host "[+] Index Position in model file: $index"
        $substringResult = $stringContent.Substring($index, [Math]::Min(200, $stringContent.Length - $index))
        Write-Host "[+] Overview of the potential threat strings:"
        Write-Host -ForegroundColor red "	$substringResult`n"
    }
} else {
    Write-Host "[+] Done. Did not find threat evidence in the model file."
}

}
