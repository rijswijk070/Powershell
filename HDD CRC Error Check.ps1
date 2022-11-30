# Created by Ivo Planje

# Versions
# 21-11-2022: Eerste versie.
# 22-11-2022: Robocopy cmd line aangepast. Pakte alleen de Hoofdir en de subs.
# 25-11-2022: Output gecosmetiseerd en counter toegevoegd.

# To-Do
# System folders in de root geven nog errors.

# Eerst de bestanden opruimen die niet nodig zijn

Remove-Item C:\Temp\* -recurse -exclude "HDD CRC Error Check.ps1",robocopy.exe,"Log files" -force

# Deze functie is voor het Browse dialoog venster, dus om de te scannen directory te selecteren.

function Read-FolderBrowserDialog([string]$Message, [string]$InitialDirectory, [switch]$NoNewFolderButton)
{
    $browseForFolderOptions = 0
    if ($NoNewFolderButton) { $browseForFolderOptions += 512 }

    $app = New-Object -ComObject Shell.Application
    $folder = $app.BrowseForFolder(0, $Message, $browseForFolderOptions, $InitialDirectory)
    if ($folder) { $selectedDirectory = $folder.Self.Path } else { $selectedDirectory = '' }
    [System.Runtime.Interopservices.Marshal]::ReleaseComObject($app) > $null
    return $selectedDirectory
}

function HDDCheck {

# Variablen

$DatumEnTijd = Get-Date -Format "dd_MM_yyyy_HH_mm"
$ScanLocation = Read-FolderBrowserDialog -Message "Please select a directory" -NoNewFolderButton
$DirectoryContent = Get-Childitem "$Scanlocation\*.*" -Exclude "System Volume Information","$RECYCLE.BIN" -recurse -Force | % { $_.FullName }
$LogFileLocation = "C:\Temp\Log Files"
$AantalBestanden = (Get-Childitem "$ScanLocation\*.*" -recurse -Force).count
$AantalBestandenNogTeGaan = (Get-Childitem "$ScanLocation\*.*" -recurse -Force).count

foreach ($File in $DirectoryContent) {

# Split Directory from Files in Scanlocation
 
$Directory = Split-Path $File+'\' -Parent
$Bestand = Split-Path $File -leaf

# Counter decrease Bestanden en RoboCopy Bestand naar C:\Temp

Write-Host

$TotaalNogTeGaan = $AantalBestandenNogTeGaan--
Write-host 'Nog'$TotaalNogTeGaan' bestand(en) te gaan ...' -ForegroundColor Cyan
Write-Host "Bestand '$File' wordt gekopieerd" -ForegroundColor Green
C:\Temp\robocopy.exe $Directory "c:\Temp\" "$Bestand" /R:0 /LOG+:"$LogFileLocation\$DatumEnTijd.RoboCopy_Logfile.txt" /nfl | Out-Null


# Verwijder Bestand uit C:\Temp, Kopieeren is gelukt; dus consistent.

if (Test-Path "C:\Temp\$Bestand") {
Start-Sleep 1
Remove-Item "C:\Temp\$Bestand" -Force
Write-Host "Bestand '$File' is CONSISTENT" -ForegroundColor Green
Write-Output "Bestand '$File' is CONSISTENT" | Out-File "$LogFileLocation\$DatumEnTijd.Bestanden in Orde.txt" -Append
}


else {

# Kopieeren van bestand is niet gelukt; dus inconsistent.

Write-Host "Bestand '$File' is INCONSISTENT, dit duidt mogelijk op een defecte sector op de HDD (Check de LogFile) !" -ForegroundColor Red
Write-Output "Bestand '$File' is INCONSISTENT, dit duidt mogelijk op een defecte sector op de HDD !"  | Out-File "$LogFileLocation\$DatumEnTijd.Bestanden Niet In Orde.txt" -Append
Get-Content "$LogFileLocation\$DatumEnTijd.RoboCopy_Logfile.txt" | Where-Object {$_ -like ‘*error*’} | Out-File "$LogFileLocation\$DatumEnTijd.CRCErrors In Robocopy.txt"
Write-Host }

}

# Samenvatting

#cls
Write-Host "Overview"
Write-Host
Write-Host "Het totaal aantal bestanden in Directory en Sub-Directory's van '$ScanLocation\' is: $AantalBestanden"

$a = @(Get-Content "$LogFileLocation\$DatumEnTijd.Bestanden in Orde.txt")
$b = $a.Length
Write-Host "Het aantal consistente bestanden is: $b"

if (Test-Path "$LogFileLocation\$DatumEnTijd.Bestanden Niet In Orde.txt") {
$a1 = @(Get-Content "$LogFileLocation\$DatumEnTijd.Bestanden Niet In Orde.txt")
$b1 = $a1.Length
Write-Host "Er zijn Inconsistente bestanden. Het aantal niet consistente bestanden is: $b1"

}

else { 

Write-Host "Er zijn geen Inconsistente bestanden :)"
Write-host }

}