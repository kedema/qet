#IN DEVELOPMENT: NOT FULLY TESTED
#Get filelist in Path, recursivly, only .elmt extension then stock theses paths in $files array
$files = @(Get-ChildItem -Path "elements" -Recurse -Include "*.elmt" | ForEach-Object { Write-Output $_.FullName })

#Define author informations 
#tag "informations" need to exist
$authorInfo = @"
Author: Kevin De Magalhaes (KDM)
Github: https://github.com/kedema
Year: 2019 
"@

if(($manufacturerSel = Read-Host "Entrez le fabricant à inserer dans les éléments à modifier. (Defaut: Generic)") -eq ''){$global:manufacturer = "Generic"}else{$global:manufacturer = "$manufacturerSel"}
Write-Host -ForegroundColor Cyan "Mention to add/change: `r`n$authorInfo"


#Foreach File in Files array
#Open, change information and save it
# /!\ May have some encoding issues in powershell >4.0/5.0, not tested for now
foreach ($file in $files) {
    Write-Host -ForegroundColor Cyan "Working in file: $file"
    $xdoc = ( Select-Xml -Path $file -XPath / ).Node
    $internalCode =  $xdoc.SelectSingleNode("/definition/elementInformations/elementInformation[@name='machine-manufacturer-reference']").InnerText
    if (($internalCodeNew = Read-Host -Prompt "Entrez le code interne de l'élément/ref. commune à tous les constructeurs: (valeur actuelle: $internalCode)") -eq -not '') {
        $xdoc.SelectSingleNode("/definition/elementInformations/elementInformation[@name='machine-manufacturer-reference']").InnerText = $internalCodeNew }
    $xdoc.SelectSingleNode("/definition/elementInformations/elementInformation[@name='manufacturer']").InnerText = $manufacturer
    $xdoc.SelectSingleNode("/definition/elementInformations/elementInformation[@name='designation']").InnerText = Read-Host -Prompt "Entrez la référence fabricant de l'élément:"
    $xdoc.SelectSingleNode("/definition/elementInformations/elementInformation[@name='comment']").InnerText = Read-Host -Prompt "Entrez le commentaire de l'élément:"
    $xdoc.SelectSingleNode("/definition/elementInformations/elementInformation[@name='description']").InnerText = Read-Host -Prompt "Entrez la description textuelle de l'élément:"
    $xdoc.Save($file)
    Write-Host -ForegroundColor Green "File $file saved. Next..."
}
Write-Host -ForegroundColor Green "All Dones."