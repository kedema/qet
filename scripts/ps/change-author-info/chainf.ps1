#Get filelist in Path, recursivly, only .elmt extension then stock theses paths in $files array
$files = @(Get-ChildItem -Path C:\PATH\TO\ELEMENTS\LIBRARY -Recurse -Include "*.elmt" | ForEach-Object { Write-Output $_.FullName })

#Define author informations 
#tag "informations" need to exist
$authorInfo = @"
Author: Kevin De Magalhaes (KDM)
Github: https://github.com/kedema
Year: 2019 
"@
Write-Host -ForegroundColor Cyan "Mention to add/change: `r`n$authorInfo"

#Foreach File in Files array
#Open, change information and save it
# /!\ May have some encoding issues in powershell >4.0/5.0, not tested for now
foreach ($file in $files) {
    Write-Host "Working in file: $file"
    $xml = New-Object -TypeName XML
    $xml.Load($file)
    $xml.definition.informations = $authorInfo
    $xml.Save($file)
}
Write-Host -ForegroundColor Green "All Dones."