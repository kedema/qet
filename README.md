# qet 

Ressources diverses pour le logiciel de schémas open source QElectroTech

## Resources disponibles:
### [Script] [PS] v1-qetpropadder (Fonctionnel)

Script powershell conçu pour ajouter des propriétés globales personnalisées selon un fichier csv donné dans le code.
Il est développé à la base pour ajouter rapidement les propriétés nécéssaire à insérer dans le cartouche (Numéro de client, nom de chantier ...)

Utilisation:

Créez un nouveau fichier powershell avec votre éditeur préféré (Le bloc-note peut suffire..), copiez le contenu du script "scripts\ps\project-starter-helper\v1-qetpropadder\alpha3-fileprompt.ps1", nommez comme il vous plaît et enregistrez, pour l'exemple nous prendrons: "qetpropadder.ps1".

Modifiez l'emplacement du fichier csv pour y mettre le votre:

```
echo "-- Loading customs properties..."
#Proprietées à ajouter
$propToAddList = Import-Csv -Path "add\properties.csv"
```
Enregistrez et fermez.

Pour executer le script, vous avez deux options: 
Simplement un clic-droit sur le fichier "qetpropadder.ps1" et exécuter avec powershell. Ou vous pouvez créer un raccourci windows avec comme paramètres: 

```
powershell.exe -ExecutionPolicy Bypass -File "Chemin\vers\qetpropadder.ps1"

```

Sélectionnez votre fichier projet .qet et le script va ajouter les proprietés à un nouveau fichier commençant par "updated_", ouvrez ce nouveau fichier avec QeletroTech et si tout c'est bien passer vos nouvelles variables sont là!

### [Script][PS] QelectroTech Network Install-helper (Partiellement fonctionnel)
Script conçu pour "centraliser" une installation QelectroTech. Scénario: 
```
L'administrateur choisit le dossier sur le serveur ($rootInstall) et y dépose la dernière version.
il maintient le numero de version dans $rootInstall\version.txt
-installation/mise a jour
On execute le script sur la machine
	installe ou met à jour l'installation
    installe les raccourcis/associations
-Réinstallation
On execute -force
	desinstalle le programme et la configuration
-Réinstallation/avec Suppression config
On execute -forceconf
	desinstalle le programme et la configuration
-Désinstallation
On execute -uninstall
	desinstalle le programme et la configuration
	supprime les raccouris/associations
```

### [Script][PS] Changement des informations d'auteur d'éléments
Changes les informations d'auteur des éléments d'un répertoire et ses sous-répertoires, pratique pour mettre à jour toute une bibliothèque.
Modifiez le "-Path" de la ligne suivante pour y pointer le dossier de vos éléments.
```
$files = @(Get-ChildItem -Path C:\PATH\TO\ELEMENTS\LIBRARY -Recurse -Include "*.elmt" | ForEach-Object { Write-Output $_.FullName })
```
Modifiez ensuite la balise "$autorInfo" pour mettre vos informations et éxecutez le script. It's done!

### [Schéma][QElectroTech|PDF] Schéma de câblage pour Fil Pilote

Des schémas de principe pour câbler des zones de chauffage avec un sonoff 4Ch R2, avec en bonus le fichier source du schéma si vous voulez le modifier ou récuperer des éléments de dessin.
Si vous avez des difficultés à ouvrir le schéma vous devrez peut-être modifier le début du fichier avec un éditeur de texte pour y insérer le chemin vers le fichier.

```
<project folioSheetQuantity="0" title="" version="0.70">
    <properties>
      ...
      <property show="1" name="savedfilepath">Chemin/vers/branchement fil pilote.qet</property>
      ...
    </properties>
```

