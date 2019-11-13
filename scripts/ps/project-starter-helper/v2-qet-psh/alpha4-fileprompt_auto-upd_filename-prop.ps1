#############################################################################
# Name : QETpropAdder														#
# Author : KDM																#
# Date: October 2019														#
# Version: Alpha 0.3 														#
# Description : Add customs properties and personalize a QET (xml) file 	#
#############################################################################

###### GENERAL ######
# Charge le nécéssaire pour afficher l'explorateur de fichiers
Add-Type -AssemblyName System.Windows.Forms

# établie les propriétes de l'explorateur 
$FileBrowser = New-Object System.Windows.Forms.OpenFileDialog -Property @{ 
    InitialDirectory = [Environment]::GetFolderPath('Desktop') 
    Filter = 'Fichiers QET (*.qet)|*.qet|Fichiers XML (*.xml)|*.xml'
}

# Affiche l'explorateur 
$null = $FileBrowser.ShowDialog()

# Décompose les informations du fichier selectionné  
$path = $FileBrowser.FileName.Substring(0,$FileBrowser.FileName.Length-$FileBrowser.SafeFileName.Length)
$file = $FileBrowser.SafeFileName
$newFile = "updated_$file"
$fullPath = $FileBrowser.FileName
$xml = New-Object -TypeName XML
$xml.Load("$fullPath")
echo "-- File: $fullPath loaded"

###### !GENERAL ######

###### PROPRIETES PROJECT ######
echo "-- Listing actuals properties..."
# Liste les propriétés actuelles contenues dans le fichier.
$propActuals = @( )
foreach ($property in $xml.project.properties.property | Where-Object {$_.show -match "1"}) {$propActuals += $property.name} 

echo "-- Loading customs Reckinger properties..."
#Proprietées à ajouter
$propToAddList = Import-Csv -Path "U:\SERVICE-ELECTRIQUE\lib\qet\add-props\rck_properties.csv"
echo "-- Adding customs Reckinger properties..."
foreach ($objItem in $propToAddList.name)
 {
	if ($propActuals -contains "$objItem") {
		echo "- Property $objItem already exist! Skipping..."
	}
	else { 
		$property = $xml.project.properties.property[0].Clone()
		$property.show = '1'
		$property.name = $propToAddList.name[$propToAddList.name.indexOf($objItem)]
		$property.InnerText = $propToAddList.text[$propToAddList.name.indexOf($objItem)]
		[void] $xml.project.properties.AppendChild($property)
		echo "- Property $objItem created."
	}
 }
# Mise à jour du nom de fichier
echo "mise à jour nom de fichiers"
$xml.project.properties.property | Where-Object {$_.name -match "savedfilepath"} { $xml.project.properties.property = 'test'}

 
###### !PROPRIETES PROJECT ######
###### PROPRIETES NEWDIAGRAMS ######

###### !PROPRIETES NEWDIAGRAMS ######


###### SAVING ######
echo "-- Saving to $path$newFile ..."
$utf8WithoutBom = New-Object System.Text.UTF8Encoding($false)
$sw = New-Object System.IO.StreamWriter("$path$newFile", $false, $utf8WithoutBom)
$xml.Save( $sw )
$sw.Close()
###### !SAVING ######