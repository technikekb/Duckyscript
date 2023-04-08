[CmdletBinding()]
param(
    [Parameter(Mandatory=$true, Position=0, HelpMessage="Path of the input file.")]
    [ValidateScript({Test-Path $_ -PathType Leaf})]
    [string]$InputFile
)

# Determine output folder and file path
$OutputFolder = Split-Path -Parent $InputFile
if ([string]::IsNullOrWhiteSpace($OutputFolder)) {
    Throw "Output folder cannot be determined from input file path."
}

$OutputFile = Join-Path -Path $OutputFolder -ChildPath "Dict_Attack.txt"
Write-Verbose "Output file path: $OutputFile"

# Create new output file or overwrite existing file
New-Item -ItemType File -Path $OutputFile -Force -ErrorAction Stop | Out-Null
Write-Verbose "Output file created successfully: $OutputFile"

# Read input file and convert to ducky script
$Delay = 500
$EnterKey = [char]13
$Lines = Get-Content $InputFile
foreach ($Line in $Lines) {
    $Command = "STRING $Line`nDELAY $Delay`n"
    $Command += "KEY $EnterKey`nDELAY $Delay`nWAIT_FOR_BUTTON_PRESS`n"
    Add-Content -Path $OutputFile -Value $Command
}
Write-Verbose "Conversion complete."
