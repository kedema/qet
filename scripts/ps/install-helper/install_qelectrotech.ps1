# Etablie les arguments du script
Param ( 
    [switch]$force,
    [switch]$forceconf,
    [switch]$uninstall
)

#Begin of user parameters

## Installations paths in Test-mode
## Remove "$testDir+"
## From $rootDir, $rootLibraries, $installDir and $clientLibraries
## and set full path folder for regular usage
$testDir = Split-Path $script:MyInvocation.MyCommand.Path

#Server (root) parameters
$rootDir = $testDir+"\server\qelectro_centralized\"
$rootInstall = $rootDir+"qetv1\"
$rootVersionFile = $rootInstall+"version.txt"
$rootLibraries = $testDir+"\server\qelectro_centralized\libraries\"

#Client (machine to install) parameters
$installDir = $testDir+"\Programs\"
$qetInstallPath = $installDir+"qelectrotech\"
$installVersionFile = $qetInstallPath+"version.txt"
$clientLibraries = $testDir+"\User\qelectro_symboles\"
#End of parameters

#Begin of variables

$rootVersion = Get-content -Path $rootVersionFile -ErrorAction SilentlyContinue
$installVersion = Get-content -Path $installVersionFile -ErrorAction SilentlyContinue
#End of variables

#Begin of functions

Function checkInstall {
    if (-not (Test-Path -LiteralPath $qetInstallPath)) {
        $global:alreadyInstall = 0
        Write-Host -ForegroundColor Cyan "Qelectrotech isn't installed, all files will be pull from the server for a fresh install."
    }
    else {
        $global:alreadyInstall = 1
        Write-Host -ForegroundColor Cyan "Qelectrotech already installed, configuration will not be copied."
        Write-Host "Synchronization will not be set and library not copied."
        Write-Host "You can force reinstall, run the script with -force ."
        Write-Host "You can force purge config and reinstall, run the script with -forceconf ."
    }
}

Function updateQelectrotech {
	echo "update fully not implemented: comment only."
    if ((Test-Path $rootVersionFile) -and (Test-Path $installVersionFile)) {
        if ($rootVersion -gt $installVersion){Write-Host -ForegroundColor Red "There is a newer version. Update needed."}
	    elseif ($rootVersion -eq $installVersion) {Write-Host -ForegroundColor Green "This is the same version. No update needed."}
	    elseif ($rootVersion -lt $installVersion) {Write-Host -ForegroundColor Cyan "The installed version is newer. No update needed. You can force reinstall with -force"}
    }
    else { Write-Host -ForegroundColor Red "Unable to retrieve number version. Abording. You can force reinstall with -force." }
}

Function installQelectrotech {
     try {
        if(-Not (Test-Path $qetInstallPath)){
            New-Item -Path $qetInstallPath -ItemType Directory | Out-Null
            Write-Host "Directory $qetInstallPath created."
        } else {Write-Host "Directory $qetInstallPath already existing."}
        Get-ChildItem -Path $rootInstall | %{ Copy-Item $_.FullName -Destination $qetInstallPath -Recurse -Force }
        Write-Host -ForegroundColor Green "Root installation files successfully copied."
     }
     catch {
        Write-Host -ForegroundColor Red "Unable to install!"
        Write-Warning -Message "$($_.Exception.Message)"
     }

}
Function purgeQelectrotech {"purge qelectrotech not yet implemented"}
Function purgeConf {"purge conf not yet implemented"}
Function purgeShortcuts {"purge shortcut not yet implemented"}
Function goodBye { Write-Host -ForegroundColor Cyan "End of script. Good Bye."}
#End of functions

#Starting script

if(-Not ($force) -and -not ($forceconf)) { checkInstall }
if($force) {
    Write-Host -ForegroundColor Red "Force option: Erase and reinstall Qelectrotech"
    purgeQelectrotech
    installQelectrotech
    goodBye
}elseif($forceconf) {
    Write-Host -ForegroundColor Red "forceConf option: Erase Qelectrotech AND configurations files. Then reinstall."
    purgeQelectrotech
    purgeConf
    installQelectrotech
    goodBye
}elseif($uninstall){
    Write-Host -ForegroundColor Red "Uninstall option: Uninstall Qelectrotech, configurations files and shortcuts"
    purgeQelectrotech
    purgeConf
    purgeShortcuts
    goodBye
}elseif($alreadyInstall -eq 1){
    Write-Host -ForegroundColor Green "Check need for updates..."
    updateQelectrotech
    goodBye
}else {
    Write-Host -ForegroundColor Green "The installation begin..."
    installQelectrotech
    goodBye
} 
#End of script