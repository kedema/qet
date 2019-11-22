#IN DEVELOPMENT: NOT FULLY TESTED
#Get filelist in Path, recursivly, only .elmt extension then stock theses paths in $files array
$files = @(Get-ChildItem -Path "elements" -Recurse -Include "*.elmt" | ForEach-Object { Write-Output $_.FullName })

#Define texts
$txtInternalCode = "Entrez le code interne de l'élément / ref. commune à tous les fabricants (Optionnel):"
$txtManufacturer = "Entrez le nom du fabricant à inserer dans les éléments à modifier. (Defaut: Generic)"
$txtDesignation = "Entrez la référence fabricant de l'élément:"
$txtComment = "Entrez le commentaire de l'élément: (Optionnel)"
$txtDescription = "Entrez la description textuelle de l'élément:"

#Define author informations 
$authorInfo = @"
Author: Kevin De Magalhaes (KDM)
Github: https://github.com/kedema
Year: 2019 
"@

Write-Host -ForegroundColor Cyan "Mention to add/change: `r`n$authorInfo"

#Config for libraries sort by manufacturer
if(($manufacturerNew = Read-Host $txtManufacturer) -eq ''){ $script:manufacturer = "Generic" }else{ $script:manufacturer = $manufacturerNew }

#Foreach File in Files array
#Open, change informations and save it
# /!\ May have some encoding issues in powershell >4.0/5.0, not tested for now
foreach ($file in $files) {
    try {
        Write-Host -ForegroundColor Cyan "Working in file: $file"
        $xdoc = ( Select-Xml -Path $file -XPath / ).Node
        $xdoc.SelectSingleNode("/definition/elementInformations/elementInformation[@name='manufacturer']").InnerText = $manufacturer
        $xdoc.SelectSingleNode("/definition/informations").InnerText = $authorInfo
        $internalCode =  $xdoc.SelectSingleNode("/definition/elementInformations/elementInformation[@name='machine-manufacturer-reference']").InnerText
        $internalCodeNew = Read-Host -Prompt "$txtInternalCode [Actual: $internalCode ]"
            if (-Not ($internalCodeNew -eq '')) { $xdoc.SelectSingleNode("/definition/elementInformations/elementInformation[@name='machine-manufacturer-reference']").InnerText = $internalCodeNew }
        $designation = $xdoc.SelectSingleNode("/definition/elementInformations/elementInformation[@name='designation']").InnerText
        $designationNew = Read-Host -Prompt "$txtDesignation [Actual: $designation ]"
            if (-Not ($designationNew -eq '')) { $xdoc.SelectSingleNode("/definition/elementInformations/elementInformation[@name='designation']").InnerText = $designationNew }
        $comment = $xdoc.SelectSingleNode("/definition/elementInformations/elementInformation[@name='comment']").InnerText
        $commentNew = Read-Host -Prompt "$txtComment [Actual: $comment ]"
            if (-Not ($commentNew -eq '')) { $xdoc.SelectSingleNode("/definition/elementInformations/elementInformation[@name='comment']").InnerText = $commentNew }
        $description = $xdoc.SelectSingleNode("/definition/elementInformations/elementInformation[@name='description']").InnerText
        $descriptionNew = Read-Host -Prompt "$txtDescription [Actual: $description ]"
            if (-Not ($descriptionNew -eq '')) { $xdoc.SelectSingleNode("/definition/elementInformations/elementInformation[@name='description']").InnerText = $descriptionNew }
        $xdoc.Save($file)
        Write-Host -ForegroundColor Green "File $file saved. Next..."
    } catch {
        Write-Host -ForegroundColor Red "Error with file, verify if tag elementInformation exist or read only file."
        Write-Warning -Message "$($_.Exception.Message)"
    }
}
Write-Host -ForegroundColor Green "All Dones."