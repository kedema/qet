# qet 

Ressources diverses pour le logiciel de schémas open source QElectroTech

## Resources disponibles:
### [PS] v1-qetpropadder (Fonctionnel)

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
