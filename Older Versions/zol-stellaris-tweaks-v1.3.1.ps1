
Write-Host "########################################"
Write-Host "###### Zolana's Stellaris Tweaks #######"
Write-Host "############ Version 1.3.1 #############"
$patcher_ver = "1.3.1"
Write-Host "########################################"
Write-Host "######## Patcher for Stellaris: ########"
Write-Host "########### v3.9.3 (Caelum) ############"
$ver = "3.9.3"
Write-Host "########################################"
Write-Host "########## Environment Setup ###########"
Write-Host "----------------------------------------"
Add-Type -AssemblyName 'PresentationFramework'
Add-Type -AssemblyName System.Windows.Forms
Write-Host "----------------------------------------"
Write-Host ">Platform:"
Write-Host "1 - Steam"
Write-Host "2 - GOG"
Write-Host "3 - Other"
Write-Host "----------------------------------------"
$platform = Read-Host "Please select your platform"
Write-Host "----------------------------------------"

# Update these to default installation paths

if($platform -eq 1){
    #$stel_path = "D:\Steam Favourites\SteamApps\common\Stellaris"
    $stel_path = "C:\Program Files (x86)\Steam\SteamApps\common\Stellaris"
    $stel_path_check = Test-Path $stel_path
}
elseif($platform -eq 2){
    $stel_path = "C:\GOG Games\Stellaris\"
    $stel_path_check = Test-Path $stel_path
}
else{$stel_path_check = $false}

if($stel_path_check){
    Write-Host ">Stellaris installation detected" -foregroundcolor "green"
}
else {
    Write-Host ">Stellaris installation not found!" -foregroundcolor "yellow"
    Write-Host "Please select your Stellaris directory:"
    $browser = New-Object System.Windows.Forms.FolderBrowserDialog
    $null = $browser.ShowDialog()
    $stel_path = $browser.SelectedPath
}
if($stel_path -eq ""){
    Write-Host "No directory selected, exiting" -foregroundcolor "red"
    pause
    exit
}
$stel_path_check = Test-Path -path "$stel_path\stellaris.exe"
if($stel_path_check -eq $false){
    Write-Host "Could not detect Stellaris.exe in selected directory. Please check you selected the correct directory. Exiting!" -foregroundcolor "red"
    Pause
    Exit
}

$stel_drive = $stel_path.SubString(0,2)
Set-Location $stel_drive
Set-Location -Path $stel_path
Write-Host ">Stellaris installation location:"
Write-Host $stel_path

Set-Location $env:HOMEDRIVE
Set-Location $env:homepath
$mod_path_check = Test-Path "documents\Paradox Interactive\Stellaris\mod\Zolana Stellaris Tweaks\zol-stellaris-tweaks-v$patcher_ver.ps1" -PathType Leaf


if($mod_path_check){
    Write-Host ">Mod directory detected" -foregroundcolor "green"
    $mod_path = "documents\Paradox Interactive\Stellaris\mod\Zolana Stellaris Tweaks" }
else {
    Write-Host ">Mod directory not found!" -foregroundcolor "yellow"

    Write-Host "Please select the mod directory where this file is saved:"
    $browser = New-Object System.Windows.Forms.FolderBrowserDialog
    $null = $browser.ShowDialog()
    $mod_path = $browser.SelectedPath
}
if($mod_path -eq $null){
    Write-Host "No directory selected, exiting" -foregroundcolor "yellow"
    pause
    exit
}

Write-Host ">Mod installation location:"
if($mod_path_check){
    $mod_path = "$env:HOMEDRIVE$env:homepath\$mod_path"
    }
Write-Host $mod_path

$mod_path_check = Test-Path -path "$mod_path\zol-stellaris-tweaks-v$patcher_ver.ps1"

if($mod_path_check -eq $false){
    Write-Host "Could not detect this script in selected directory. Please check you selected the correct directory. Exiting!" -foregroundcolor "red"
    Pause
    Exit
}


Write-Host "########################################"
Write-Host "####### Installation Verification ######"
Write-Host "----------------------------------------"
Write-Host ">Verifying Patcher..."
Set-Location $env:HOMEDRIVE
Set-Location $env:homepath
Set-Location -Path $mod_path
$mod_hash = Get-FileHash "zol-stellaris-tweaks-v$patcher_ver.ps1" -Algorithm SHA256
Write-Host ">Script Hash:"
Write-Host $mod_hash.hash

[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
$hashurl = "http://raw.githubusercontent.com/ZolanaPrime/stellaris-small-tweaks/main/sha256-v$patcher_ver.txt"
$check_hash = Invoke-webrequest -URI $hashurl
$check_hash = $check_hash.ToString()
Write-Host ">Expected Hash:"
Write-Host $check_hash

if ($check_hash -ne $mod_hash.hash){
    Write-Host ">Warning - the mod could not be verified, and may have been altered. Continue at your own risk!" -foregroundcolor "red"
        
    Write-Host "1 - Continue"
    Write-Host "2 - Exit"
    Write-Host "----------------------------------------"

    $continue = Read-Host "Do you wish to continue?"
        if ($continue -ne 1){
            Exit
            }


}
if ($check_hash -eq $mod_hash.hash){
    Write-Host ">Mod hash verified!" -foregroundcolor "green"
}

Write-Host "----------------------------------------"
Write-Host ">Checking for Patcher updates..."
Set-Location $env:HOMEDRIVE
Set-Location $env:homepath
Set-Location -Path $mod_path


[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
$verurl = "https://raw.githubusercontent.com/ZolanaPrime/stellaris-small-tweaks/main/latest-ver.txt"
$check_ver = Invoke-webrequest -URI $verurl
$check_ver = $check_ver.ToString()


if ($check_ver -ne $patcher_ver){
    
    Write-Host ">Patcher Version:"
    Write-Host $patcher_ver -foregroundcolor "yellow"
    Write-Host ">Latest Version:"
    Write-Host $check_ver -foregroundcolor "green"
    
    Write-Host ">A new version of the patcher is available to download from https://github.com/ZolanaPrime/stellaris-small-tweaks" -foregroundcolor "cyan"
        
    Write-Host "1 - Continue"
    Write-Host "2 - Exit"
    Write-Host "3 - Exit and open GitHub download page"
    Write-Host "----------------------------------------"

    $choice = Read-Host "Please select an option"
        if ($choice -eq 2){
            Exit
            }
        elseif ($choice -eq 3){
            Start-Process "https://github.com/ZolanaPrime/stellaris-small-tweaks/releases"
            Exit
            }
        else{}

}
elseif ($check_ver -eq $patcher_ver){
    Write-Host ">Patcher Version:"
    Write-Host v$patcher_ver -foregroundcolor "green"
    Write-Host ">This version is up to date!"
}

Set-Location $stel_drive
Set-Location -Path $stel_path
Write-Host "----------------------------------------"
Write-Host ">Detecting installed Stellaris version:"
$file = "launcher-settings.json"
$content = Get-Content -Path $file
$stell_ver_raw = $content[37]
$stell_ver = $stell_ver_raw.SubString(19,$stell_ver_raw.Length-21)

if($ver -ne $stell_ver){
    Write-Host v$stell_ver -foregroundcolor "red"

    Write-Host = "Your version of Stellaris differs from the version this tool is designed for. Continuing may cause errors." -foregroundcolor "red" 
    Write-Host "1 - Continue"
    Write-Host "2 - Exit"
    Write-Host "----------------------------------------"

    $continue = Read-Host "Do you wish to continue?"
        if ($continue -ne 1){
            Exit
            }


    Write-Host ">Version mismatch detected! Continuing anyway!" -foregroundcolor "red"
}
else{
    Write-Host v$stell_ver -foregroundcolor "green"
}

Write-Host "----------------------------------------"
Write-Host ">Detecting DLCs..."
$dlc_plant = Test-Path "dlc\dlc004_plantoid\dlc004.dlc"
if($dlc_plant){Write-Host ">Detected Plantoids Species Pack" -foregroundcolor "green"}
else {Write-Host ">Plantoids Species Pack Not Detected" -foregroundcolor "red"}

$dlc_lev = Test-Path "dlc\dlc012_leviathans\dlc012.dlc"
if($dlc_lev){Write-Host ">Detected Leviathans Story Pack" -foregroundcolor "green"}
else {Write-Host ">Leviathans Story Pack Not Detected" -foregroundcolor "red"}

$dlc_hs = Test-Path "dlc\dlc013_horizon_signal\dlc013.dlc"
if($dlc_hs){Write-Host ">Detected Horizon Signal Event" -foregroundcolor "green"}
else {Write-Host ">Plantoids Species Pack Not Detected" -foregroundcolor "red"}

$dlc_utopia = Test-Path "dlc\dlc014_utopia\dlc014.dlc"
if($dlc_utopia){Write-Host ">Detected Utopia Expansion" -foregroundcolor "green"}
else {Write-Host ">Utopia Expansion Not Detected" -foregroundcolor "red"}

$dlc_syndawn = Test-Path "dlc\dlc016_synthetic_dawn\dlc016.dlc"
if($dlc_syndawn){Write-Host ">Detected Synthetic Dawn Story Pack" -foregroundcolor "green"}
else {Write-Host ">Synthetic Dawn Story Pack Not Detected" -foregroundcolor "red"}

$dlc_apocalypse = Test-Path "dlc\dlc017_apocalypse\dlc017.dlc"
if($dlc_apocalypse){Write-Host ">Detected Apocalypse Expansion" -foregroundcolor "green"}
else {Write-Host ">Apocalypse Expansion Not Detected" -foregroundcolor "red"}

$dlc_humanoids = Test-Path "dlc\dlc018_humanoids\dlc018.dlc"
if($dlc_humanoids){Write-Host ">Detected Humanoids Species Pack" -foregroundcolor "green"}
else {Write-Host ">Humanoids Species Pack Not Detected" -foregroundcolor "red"}

$dlc_diststars = Test-Path "dlc\dlc019_distant_stars\dlc019.dlc"
if($dlc_diststars){Write-Host ">Detected Distant Stars Story Pack" -foregroundcolor "green"}
else {Write-Host ">Distant Stars Story Pack Not Detected" -foregroundcolor "red"}

$dlc_megacorp = Test-Path "dlc\dlc020_megacorp\dlc020.dlc"
if($dlc_megacorp){Write-Host ">Detected Megacorp Expansion" -foregroundcolor "green"}
else {Write-Host ">Megacorp Expansion Not Detected" -foregroundcolor "red"}

$dlc_ancrel = Test-Path "dlc\dlc021_ancient_relics\dlc021.dlc"
if($dlc_ancrel){Write-Host ">Detected Ancient Relics Story Pack" -foregroundcolor "green"}
else {Write-Host ">Ancient Relics Story Pack Not Detected" -foregroundcolor "red"}

$dlc_lithoids = Test-Path "dlc\dlc022_lithoids\dlc022.dlc"
if($dlc_lithoids){Write-Host ">Detected Lithoids Species Pack" -foregroundcolor "green"}
else {Write-Host ">Lithoids Species Pack Not Detected" -foregroundcolor "red"}

$dlc_federations = Test-Path "dlc\dlc023_federations\dlc023.dlc"
if($dlc_federations){Write-Host ">Detected Federations Expansion" -foregroundcolor "green"}
else {Write-Host ">Federations Expansion Not Detected" -foregroundcolor "red"}

$dlc_necroids = Test-Path "dlc\dlc024_necroids\dlc024.dlc"
if($dlc_necroids){Write-Host ">Detected Necroids Species Pack" -foregroundcolor "green"}
else {Write-Host ">Necroids Species Pack Not Detected" -foregroundcolor "red"}

$dlc_nem = Test-Path "dlc\dlc025_nemesis\dlc025.dlc"
if($dlc_nem){Write-Host ">Detected Nemesis Expansion" -foregroundcolor "green"}
else {Write-Host ">Nemesis Expansion Not Detected" -foregroundcolor "red"}

$dlc_aquatics = Test-Path "dlc\dlc026_aquatics\dlc026.dlc"
if($dlc_aquatics){Write-Host ">Detected Aquatics Species Pack" -foregroundcolor "green"}
else {Write-Host ">Aquatics Species Pack Not Detected" -foregroundcolor "red"}

$dlc_overlord = Test-Path "dlc\dlc027_overlord\dlc027.dlc"
if($dlc_overlord){Write-Host ">Detected Overlord Expansion" -foregroundcolor "green"}
else {Write-Host ">Overlord Expansion Not Detected" -foregroundcolor "red"}

$dlc_toxoids = Test-Path "dlc\dlc028_toxoids\dlc028.dlc"
if($dlc_toxoids){Write-Host ">Detected Toxoids Species Pack" -foregroundcolor "green"}
else {Write-Host ">Toxoids Species Pack Not Detected" -foregroundcolor "red"}

$dlc_firstcon = Test-Path "dlc\dlc029_firstcontact\dlc029.dlc"
if($dlc_firstcon){Write-Host ">Detected First Contact Story Pack" -foregroundcolor "green"}
else {Write-Host ">First Contact Story Pack Not Detected" -foregroundcolor "red"}

$dlc_galpar = Test-Path "dlc\dlc030_paragon\dlc030.dlc"
if($dlc_galpar){Write-Host ">Detected Galactic Paragons Expansion" -foregroundcolor "green"}
else {Write-Host ">Galactic Paragons Expansion Not Detected" -foregroundcolor "red"}

Write-Host "----------------------------------------"

# Select install mode, or restore backup

Write-Host ">Available modes:"
Write-Host "1 - Apply tweaks"
Write-Host "2 - Restore backup"
Write-Host "3 - Exit"
Write-Host "----------------------------------------"

$mode = Read-Host "Please select an option"
if($mode -eq 1){

# Back up existing files

Set-Location $stel_drive
Set-Location -Path $stel_path

Write-Host "########################################"
Write-Host "########### Creating Backup ############"
Write-Host "########################################"

if((Test-Path $mod_path\backups) -eq $false){$null = New-Item -Path $mod_path\backups -ItemType Directory}
Write-Host "----------------------------------------"
Write-Host ">Backup Options:"
Write-Host "1 - Create Backup (any existing backup will be overwritten!)"
Write-Host "2 - Skip Backup"
Write-Host "----------------------------------------"
$backup_create = Read-Host "Please select an option"
Write-Host "----------------------------------------"
if($backup_create -eq 1){

    Copy-Item -Path $stel_path\common\federation_types\00_federation_types.txt -Destination $mod_path\backups
    Write-Host ">Backed up 00_federation_types.txt"

    Copy-Item -Path $stel_path\common\on_actions\00_on_actions.txt -Destination $mod_path\backups
    Write-Host ">Backed up 00_on_actions.txt"
    
    Copy-Item -Path $stel_path\common\solar_system_initializers\distant_stars_initializers.txt -Destination $mod_path\backups
    Write-Host ">Backed up distant_stars_initializers.txt"
    
    Copy-Item -Path $stel_path\common\solar_system_initializers\leviathans_system_initializers.txt -Destination $mod_path\backups
    Write-Host ">Backed up leviathans_system_initializers.txt"
    
    Copy-Item -Path $stel_path\common\solar_system_initializers\pre_ftl_initializers.txt -Destination $mod_path\backups
    Write-Host ">Backed up pre_ftl_initializers.txt"

    Copy-Item -Path $stel_path\events\ancient_relics_arcsite_events_2.txt -Destination $mod_path\backups
    Write-Host ">Backed up ancient_relics_arcsite_events_2.txt"

    Copy-Item -Path $stel_path\events\central_crystal_events.txt -Destination $mod_path\backups
    Write-Host ">Backed up central_crystal_events.txt"

    Copy-Item -Path $stel_path\events\distant_stars_events_3.txt -Destination $mod_path\backups
    Write-Host ">Backed up distant_stars_events_3.txt"

    Copy-Item -Path $stel_path\events\utopia_shroud_events.txt -Destination $mod_path\backups
    Write-Host ">Backed up utopia_shroud_events.txt"

    Copy-Item -Path $stel_path\events\fallen_empire_awakening_events.txt -Destination $mod_path\backups
    Write-Host ">Backed up fallen_empire_awakening_events.txt"
    
    Copy-Item -Path $stel_path\common\defines\00_defines.txt -Destination $mod_path\backups
    Write-Host ">Backed up 00_defines.txt"    

    Copy-Item -Path $stel_path\events\marauder_events.txt -Destination $mod_path\backups
    Write-Host ">Backed up marauder_events.txt"

    Copy-Item -Path $stel_path\events\caravaneer_events.txt -Destination $mod_path\backups
    Write-Host ">Backed up caravaneer_events.txt"
    
    Copy-Item -Path $stel_path\common\technology\00_eng_tech.txt -Destination $mod_path\backups
    Write-Host ">Backed up 00_eng_tech.txt"

}

elseif($backup_create -eq 2){
    Write-Host "Skipping backup!" -foregroundcolor "yellow"}

else{
    Write-Host "Invalid option selected, exiting!" -foregroundcolor "yellow"
    pause
    exit
}
Write-Host "----------------------------------------"

# Patches Start Here

Write-Host "########################################"
Write-Host "############ Begin Updates  ############"
Write-Host "########################################"

Write-Host "########### Patching Systems ###########"
Write-Host "----------------------------------------"
Write-Host ">Base Game:"
# Sanctuary

$file = "common\solar_system_initializers\pre_ftl_initializers.txt"
$content = Get-Content $file
$search="### The Sanctuary"
$line  = Get-Content $file | 
   Select-String $search | 
   Select-Object -First 1 | 
   Select-Object -ExpandProperty LineNumber

$data = $content[$line+19]
$check = "	scaled_spawn_chance = 2	# scales by galaxy size (1000 stars = 10x base)"
$check2 = "	scaled_spawn_chance = 9999	# scales by galaxy size (1000 stars = 10x base)"
if(($data -eq $check) -or ($data -eq $check2)){
Write-Host ">Sanctuary Unique System"
Write-Host "0 - Skip"
Write-Host "1 - Guarantee Spawn"
Write-Host "2 - Vanilla Spawn Rate"
$choice = Read-Host "Please select an option"
if($choice -eq 1){
$content[$line+19] = '	scaled_spawn_chance = 9999	# scales by galaxy size (1000 stars = 10x base)'
$content | Set-Content -Path $file
Write-Host "Guaranteed Spawn: Sanctuary"
}
elseif($choice -eq 2){
$content[$line+19] = '	scaled_spawn_chance = 2	# scales by galaxy size (1000 stars = 10x base)'
$content | Set-Content -Path $file
Write-Host "Vanilla Spawn Rate: Sanctuary"
}
else{
    Write-Host "Skipped" -foregroundcolor "yellow"
}
}

else {
Write-Host "Guaranteed Spawn: Sanctuary - Unable to locate parameter. File may be edited by other mods, skipping" -foregroundcolor "yellow"
}
Write-Host "----------------------------------------"
# Ultima Vigilis (in Base Game)
# (only if no First Contact, otherwise do it further on along with Ithome Cluster - as events are linked - vanilla behaviour = neither or one only)

if($dlc_firstcon -eq $false){

    $file = "events\ancient_relics_arcsite_events_2.txt"
$content = Get-Content $file
$search="### Surveillance Supercomputer"
$line  = Get-Content $file | 
   Select-String $search | 
   Select-Object -First 1 | 
   Select-Object -ExpandProperty LineNumber

$data = $content[$line+8]
$check = "			2 = { } # nothing"
$check2 = "			#2 = { } # nothing"
if(($data -eq $check) -or ($data -eq $check2)){
Write-Host ">Ultima Vigilis Unique System"
Write-Host "0 - Skip"
Write-Host "1 - Guarantee Spawn"
Write-Host "2 - Vanilla Spawn Rate"
$choice = Read-Host "Please select an option"
if($choice -eq 1){
$content[$line+8] = "			#2 = { } # nothing"
$content | Set-Content -Path $file
Write-Host "Guaranteed Spawn: Ultima Vigilis"
}
elseif($choice -eq 2){
$content[$line+8] = "			2 = { } # nothing"
$content | Set-Content -Path $file
Write-Host "Vanilla Spawn Rate: Ultima Vigilis"
}
else{
    Write-Host "Skipped" -foregroundcolor "yellow"
}
}

else {
Write-Host "Guaranteed Spawn: Ultima Vigilis - Unable to locate parameter. File may be edited by other mods, skipping" -foregroundcolor "yellow"
}
}
else{}

if($dlc_firstcon){
    $file = "events\ancient_relics_arcsite_events_2.txt"
    $content = Get-Content -Path $file
    $search="### Surveillance Supercomputer"
    $line  = Get-Content $file | 
    Select-String $search | 
    Select-Object -First 1 | 
    Select-Object -ExpandProperty LineNumber
    
    $data = $content[$line+8]
    $check = "			2 = { } # nothing"
    $check2 = "			#2 = { } # nothing"
    if(($data -eq $check) -or ($data -eq $check2)){
    Write-Host ">First Contact Story Pack:"
    Write-Host ">Ultima Vigilis/Ithome Cluster (The Chosen)"
    Write-Host "0 - Skip"
    Write-Host "1 - Guarantee Spawn: Ultima Vigilis Only"
    Write-Host "2 - Guarantee Spawn: Ithome Cluster (The Chosen) Only"
    Write-Host "3 - Guarantee Spawn: Both"
    Write-Host "4 - Vanilla Spawn Behaviour"
    $choice = Read-Host "Please select an option"

    if($choice -eq 1){
        $content[$line+8] = '			#2 = { } # nothing'
        $content[$line+14] = '#			1 = {'
        $content[$line+21] = '#				}'
        $content | Set-Content -Path $file
        Write-Host "Guaranteed Spawn: Ultima Vigilis"
    }
    elseif($choice -eq 2){
        $content[$line+8] = '			#2 = { } # nothing'
        $content[$line+9] = '#			1 = {'
        $content[$line+13] = '#				}'
        $content | Set-Content -Path $file
        Write-Host "Guaranteed Spawn: Ithome Cluster (The Chosen)"
    }
    elseif($choice -eq 3){
        $content[$line+8] = '			#2 = { } # nothing'
        $content[$line+9] = '			1 = {'
        $content[$line+13] = '				}}'
        $content[$line+14] = '			random_list = {1 = {'
        $content[$line+21] = '				}'
        $content[$line+23] = '		}'
        $content | Set-Content -Path $file
        Write-Host "Guaranteed Spawn: Ultima Vigilis and Ithome Cluster (The Chosen)"
    }
    elseif($choice -eq 4){
        $content[$line+7] = '		random_list = {'
        $content[$line+8] = '			2 = { } # nothing'
        $content[$line+9] = '			1 = {'
        $content[$line+13] = '				}'
        $content[$line+14] = '			1 = {'
        $content[$line+21] = '				}'
        $content[$line+23] = '		}'
        $content | Set-Content -Path $file
        Write-Host "Vanilla Spawn Rate: Ultima Vigilis and Ithome Cluster (The Chosen)"
    }
    else{
        Write-Host "Skipped" -foregroundcolor "yellow"
    }

}
else {
    Write-Host "Guaranteed Spawn: Ultima Vigilis/Ithome Cluster - Unable to locate parameter. File may be edited by other mods, skipping" -foregroundcolor "yellow"
    }
}

Write-Host "----------------------------------------"
Write-Host ">Distant Stars Story Pack:"
if($dlc_diststars){
# Great Wound

$file = "common\solar_system_initializers\distant_stars_initializers.txt"
$content = Get-Content $file
$search="# Great Wound"
$line  = Get-Content $file | 
   Select-String $search | 
   Select-Object -First 1 | 
   Select-Object -ExpandProperty LineNumber

$data = $content[$line+18]
$check = "	scaled_spawn_chance = 8	# scales by galaxy size (1000 stars = 10x base)"
$check2 = "	scaled_spawn_chance = 9999	# scales by galaxy size (1000 stars = 10x base)"
if(($data -eq $check) -or ($data -eq $check2)){
Write-Host ">Great Wound Unique System"
Write-Host "0 - Skip"
Write-Host "1 - Guarantee Spawn"
Write-Host "2 - Vanilla Spawn Rate"
$choice = Read-Host "Please select an option"
if($choice -eq 1){
$content[$line+18] = '	scaled_spawn_chance = 9999	# scales by galaxy size (1000 stars = 10x base)'
$content | Set-Content -Path $file
Write-Host "Guaranteed Spawn: Great Wound"
}
elseif($choice -eq 2){
$content[$line+18] = '	scaled_spawn_chance = 8	# scales by galaxy size (1000 stars = 10x base)'
$content | Set-Content -Path $file
Write-Host "Vanilla Spawn Rate: Great Wound"
}
else{
    Write-Host "Skipped" -foregroundcolor "yellow"
}
}

else {
Write-Host "Guaranteed Spawn: Great Wound - Unable to locate parameter. File may be edited by other mods, skipping" -foregroundcolor "yellow"
}

}
else {
    Write-Host "DLC not detected, skipping." -foregroundcolor "yellow"
}

Write-Host "----------------------------------------"
Write-Host "########################################"
Write-Host "########### Patching Events ############"
Write-Host "----------------------------------------"
Write-Host ">Base Game:"
#Crystalline Empire
$file = "events\central_crystal_events.txt"
$content = Get-Content -Path $file

$search="# Start Events"
$line  = Get-Content $file | 
   Select-String $search | 
   Select-Object -First 1 | 
   Select-Object -ExpandProperty LineNumber

$data = $content[$line+9]
$check = "			has_origin = origin_void_dwellers"
$check2 = "			#"
if(($data -eq $check) -or ($data -eq $check2)){
Write-Host ">Crystalline Empire Event"
Write-Host "0 - Skip"
Write-Host "1 - Guarantee Trigger"
Write-Host "2 - Vanilla Trigger Rate"
$choice = Read-Host "Please select an option"
if($choice -eq 1){
$content[$line+9] = '			#'
Write-Host "Removed Crystalline Empire origin requirements"
$content[$line+15] = '			chance = 9999'
$content | Set-Content -Path $file
Write-Host "Guaranteed Event Trigger: Crystalline Empire Spawn (on reaching mid-game year)"
}
elseif($choice -eq 2){
$content[$line+9] = '			has_origin = origin_void_dwellers'
Write-Host "Restored Crystalline Empire origin requirements"
$content[$line+15] = '			chance = 1'
$content | Set-Content -Path $file
Write-Host "Vanilla Event Chances: Crystalline Empire Spawn (on reaching mid-game year)"
}
else{
    Write-Host "Skipped" -foregroundcolor "yellow"
}
}

else {
Write-Host "Guaranteed Event Trigger: Crystalline Empire Spawn - Unable to locate parameter. File may be edited by other mods, skipping" -foregroundcolor "yellow"
}

Write-Host "----------------------------------------"
# Horizon Signal
if($dlc_hs){
Write-Host ">Horizon Signal Event:"
$file = "common\on_actions\00_on_actions.txt"
$content = Get-Content -Path $file

$search="on_game_start = {"
$line  = Get-Content $file | 
   Select-String $search | 
   Select-Object -First 1 | 
   Select-Object -ExpandProperty LineNumber

$data = $content[$line+18]
$check = "		19 = 0"
$check2 = "			#"
if(($data -eq $check) -or ($data -eq $check2)){
Write-Host ">Horizon Signal Event"
Write-Host "0 - Skip"
Write-Host "1 - Guarantee Trigger"
Write-Host "2 - Vanilla Trigger Rate"
$choice = Read-Host "Please select an option"
if($choice -eq 1){
$content[$line+18] = '			#'
$content | Set-Content -Path $file
Write-Host "Guaranteed Event Trigger: Horizon Signal"
}
elseif($choice -eq 2){
$content[$line+18] = "		19 = 0"

$content | Set-Content -Path $file
Write-Host "Vanilla Event Chances: Horizon Signal"
}
else{
    Write-Host "Skipped" -foregroundcolor "yellow"
}
}
else {
Write-Host "Guaranteed Event Trigger: Horizon Signal - Unable to locate parameter. File may be edited by other mods, skipping" -foregroundcolor "yellow"
}
}

else{
     Write-Host "DLC not detected, skipping." -foregroundcolor "yellow"
}



Write-Host "----------------------------------------"
Write-Host ">Utopia Expansion:"
if($dlc_utopia){
#End of the Cycle Odds
$file = "events\utopia_shroud_events.txt"
$content = Get-Content -Path $file
$search="				country_event = { id = utopia.3307 }"
$line  = Get-Content $file | 
   Select-String $search | 
   Select-Object -First 1 | 
   Select-Object -ExpandProperty LineNumber

$data = $content[$line+1]
$check = "			2 = {"
$check2 = "25 = {"
if(($data -eq $check) -or ($data -eq $check2)){
Write-Host ">End of the Cycle Appearance Odds"
Write-Host "0 - Skip"
Write-Host "1 - Equal Odds as other patrons"
Write-Host "2 - Vanilla Appearance Odds"
$choice = Read-Host "Please select an option"
if($choice -eq 1){
$content[$line+1] = '25 = {'
$content | Set-Content -Path $file
Write-Host "Increased End of the Cycle appearance odds (now equal odds with other patrons)"
}
elseif($choice -eq 2){
$content[$line+1] = "			2 = {"

$content | Set-Content -Path $file
Write-Host "Vanilla End of the Cycle appearance odds"
}
else{
    Write-Host "Skipped" -foregroundcolor "yellow"
}
}
else {
Write-Host "End of the Cycle appearance odds - Unable to locate parameter. File may be edited by other mods, skipping" -foregroundcolor "yellow"
}
}
else {
    Write-Host "DLC not detected, skipping." -foregroundcolor "yellow"
}

Write-Host "----------------------------------------"
Write-Host ">Apocalypse Expansion:"

if($dlc_apocalypse){
$file = "events\marauder_events.txt"
    $content = Get-Content -Path $file
    
    $search="# CRISIS BEGINS"
    $line  = Get-Content $file | 
       Select-String $search | 
       Select-Object -First 1 | 
       Select-Object -ExpandProperty LineNumber
    
    $data = $content[$line+33]
    $check = "		years = 100"
    $check2 = "		days = 1"
    
        if(($data -eq $check) -or ($data -eq $check2)){

            Write-Host ">Great Khan Event"
            Write-Host "0 - Skip"
            Write-Host "1 - Guarantee Trigger"
            Write-Host "2 - Vanilla Trigger Rate"
            $choice = Read-Host "Please select an option"
            if($choice -eq 1){
            $content[$line+33] = '		days = 1' # not strictly a guaranteed spawn, but close enough
            $content | Set-Content -Path $file
            Write-Host "Guaranteed Event Trigger: Great Khan"
            }
            elseif($choice -eq 2){
            $content[$line+33] = "		years = 100"

            $content | Set-Content -Path $file
            Write-Host "Vanilla Event Chances: Great Khan"
            }
            else{
                Write-Host "Skipped" -foregroundcolor "yellow"
            }
        }
else {
    Write-Host "Guarantee Great Khan - Unable to locate parameter. File may be edited by other mods, skipping" -foregroundcolor "yellow"
    }
}
else {
    Write-Host "DLC not detected, skipping." -foregroundcolor "yellow"
}

Write-Host "----------------------------------------"
Write-Host ">Megacorp Expansion:"

if($dlc_megacorp){

$file = "events\caravaneer_events.txt"
    $content = Get-Content -Path $file
    
    $search="			# Galatron"
    $line  = Get-Content $file | 
       Select-String $search | 
       Select-Object -First 1 | 
       Select-Object -ExpandProperty LineNumber
    
    $data = $content[$line]
    $check = "			1 = {"
    $check2 = "			1000000000 = {"
    
        if(($data -eq $check) -or ($data -eq $check2)){

            Write-Host ">Galatron Spawn Chances (in Caravaneer Loot Boxes)"
            Write-Host "0 - Skip"
            Write-Host "1 - Guarantee Spawn"
            Write-Host "2 - Vanilla Odds"
            $choice = Read-Host "Please select an option"
            if($choice -eq 1){
            $content[$line] = '			1000000000 = {' 
            $content | Set-Content -Path $file
            Write-Host "Guaranteed Spawn: The Galatron"
            }
            elseif($choice -eq 2){
            $content[$line] = "			1 = {"

            $content | Set-Content -Path $file
            Write-Host "Vanilla Spawn Odds: The Galatron"
            }
            else{
                Write-Host "Skipped" -foregroundcolor "yellow"
            }
        }
else {
    Write-Host "Guarantee Galatron Spawn - Unable to locate parameter. File may be edited by other mods, skipping" -foregroundcolor "yellow"
    }
}




else {
    Write-Host "DLC not detected, skipping." -foregroundcolor "yellow"
}

Write-Host "----------------------------------------"
Write-Host ">Leviathans Story Pack:"


if($dlc_lev){
    $file = "events\fallen_empire_awakening_events.txt"
    $content = Get-Content -Path $file
    
    $search="			country_event = { id = planet_destruction.611 days = 5 }"
    $line  = Get-Content $file | 
       Select-String $search | 
       Select-Object -First 1 | 
       Select-Object -ExpandProperty LineNumber
    
    $data = $content[$line+60]
    $check = "				40 = { # No War in Heaven"
    $check2 = "				0 = { # No War in Heaven"
    
        if(($data -eq $check) -or ($data -eq $check2)){
            Write-Host ">War in Heaven (requires at least 2 Awakened Fallen Empires)?"
            Write-Host "0 - Skip"
            Write-Host "1 - Always"
            Write-Host "2 - Never"
            Write-Host "3 - Vanilla Behaviour"
            $choice = Read-Host "Please select an option"
            if($choice -eq 1){
                $content[$line+6] = '				40 = { # War in Heaven with Fallen Empire of opposing ethos'
                $content[$line+41] = '				20 = { # War in Heaven with Fallen Empire of different ethos'
                $content[$line+60] = '				0 = { # No War in Heaven'
                $content | Set-Content -Path $file
                Write-Host "War in Heaven will always trigger (when >= 2 Awakened Fallen Empires)"
            }
            elseif($choice -eq 2){
                $content[$line+6] = '				0 = { # War in Heaven with Fallen Empire of opposing ethos'
                $content[$line+41] = '				0 = { # War in Heaven with Fallen Empire of different ethos'
                $content[$line+60] = '				40 = { # No War in Heaven'
                $content | Set-Content -Path $file
                Write-Host "War in Heaven will never trigger"
            }
            elseif($choice -eq 3){
                $content[$line+6] = '				40 = { # War in Heaven with Fallen Empire of opposing ethos'
                $content[$line+41] = '				20 = { # War in Heaven with Fallen Empire of different ethos'
                $content[$line+60] = '				40 = { # No War in Heaven'
                $content | Set-Content -Path $file
                Write-Host "Default War in Heaven trigger conditions"
                
                }
            else{
                Write-Host "Skipped" -foregroundcolor "yellow"
            }

}
else {
    Write-Host "Guarantee War in Heaven - Unable to locate parameter. File may be edited by other mods, skipping" -foregroundcolor "yellow"
    }
}
else {
    Write-Host "DLC not detected, skipping." -foregroundcolor "yellow"
}

Write-Host "----------------------------------------"
Write-Host ">Ancient Relics Story Pack:"
if($dlc_ancrel){
# Guarantee relic capture after capital invasion
$file = "events\ancient_relics_arcsite_events_2.txt"
$content = Get-Content -Path $file

$search="### RELIC THEFT"
$line  = Get-Content $file | 
   Select-String $search | 
   Select-Object -First 1 | 
   Select-Object -ExpandProperty LineNumber

$data = $content[$line+30]
$check = "			100 = {}"
$check2 = "#			100 = {}"
if(($data -eq $check) -or ($data -eq $check2)){
Write-Host ">Steal Relic upon capital world invasion"
Write-Host "0 - Skip"
Write-Host "1 - Guarantee Relic Theft"
Write-Host "2 - Vanilla Odds"
$choice = Read-Host "Please select an option"
if($choice -eq 1){
$content[$line+30] = '#			100 = {}'
$content | Set-Content -Path $file
Write-Host "Guaranteed Capturing Relics when capital world invaded"
}
elseif($choice -eq 2){
$content[$line+30] = '			100 = {}'

$content | Set-Content -Path $file
Write-Host "Vanilla Relic Capture Rate"
}
else{
    Write-Host "Skipped" -foregroundcolor "yellow"
}
}
else {
Write-Host "Guaranteed Relic Capture - Unable to locate parameter. File may be edited by other mods, skipping" -foregroundcolor "yellow"
}

}
else {
    Write-Host "DLC not detected, skipping." -foregroundcolor "yellow"
}

Write-Host "----------------------------------------"
Write-Host "########################################"
Write-Host "########## Patching Guardians ##########"
Write-Host "----------------------------------------"
Write-Host ">Leviathans Story Pack:"
if($dlc_lev){
#Guardians
$file = "common\solar_system_initializers\leviathans_system_initializers.txt"
$content = Get-Content -Path $file

#Stellar Devourer

$search="# Stellarites"
$line  = Get-Content $file | 
   Select-String $search | 
   Select-Object -First 1 | 
   Select-Object -ExpandProperty LineNumber

$data = $content[$line+23]
$check = "	scaled_spawn_chance = 8	# scales by galaxy size (1000 stars = 10x base)"
$check2 = "	scaled_spawn_chance = 9999	# scales by galaxy size (1000 stars = 10x base)"
if(($data -eq $check) -or ($data -eq $check2)){
Write-Host ">Stellarite Leviathan"
Write-Host "0 - Skip"
Write-Host "1 - Guarantee Spawn"
Write-Host "2 - Vanilla Spawn Rate"
$choice = Read-Host "Please select an option"
if($choice -eq 1){
$content[$line+23] = '	scaled_spawn_chance = 9999	# scales by galaxy size (1000 stars = 10x base)'
$content | Set-Content -Path $file
Write-Host "Guaranteed Spawn: Stellar Devourer"
}
elseif($choice -eq 2){
$content[$line+23] = '	scaled_spawn_chance = 8	# scales by galaxy size (1000 stars = 10x base)'
$content | Set-Content -Path $file
Write-Host "Vanilla Spawn Rate: Stellar Devourer"
}

else{
    Write-Host "Skipped" -foregroundcolor "yellow"
}
}
else {
Write-Host "Guaranteed Spawn: Stellar Devourer - Unable to locate parameter. File may be edited by other mods, skipping" -foregroundcolor "yellow"
}

Write-Host "----------------------------------------"

#Ether Drake
$search="### Ether Drake"
$line  = Get-Content $file | 
   Select-String $search | 
   Select-Object -First 1 | 
   Select-Object -ExpandProperty LineNumber

$data = $content[$line+24]
$check = "	scaled_spawn_chance = 8	# scales by galaxy size (1000 stars = 10x base)"
$check2 = "	scaled_spawn_chance = 9999	# scales by galaxy size (1000 stars = 10x base)"
if(($data -eq $check) -or ($data -eq $check2)){
Write-Host ">Ether Drake Leviathan"
Write-Host "0 - Skip"
Write-Host "1 - Guarantee Spawn"
Write-Host "2 - Vanilla Spawn Rate"
$choice = Read-Host "Please select an option"
if($choice -eq 1){
$content[$line+24] = '	scaled_spawn_chance = 9999	# scales by galaxy size (1000 stars = 10x base)'
$content | Set-Content -Path $file
Write-Host "Guaranteed Spawn: Ether Drake"
}
elseif($choice -eq 2){
$content[$line+24] = '	scaled_spawn_chance = 8	# scales by galaxy size (1000 stars = 10x base)'
$content | Set-Content -Path $file
Write-Host "Vanilla Spawn Rate: Ether Drake"
}
else{
    Write-Host "Skipped" -foregroundcolor "yellow"
}
}
else {
Write-Host "Guaranteed Spawn: Ether Drake - Unable to locate parameter. File may be edited by other mods, skipping" -foregroundcolor "yellow"
}

Write-Host "----------------------------------------"

#Dimensional Horror
$search="# Dimensional Horror"
$line  = Get-Content $file | 
   Select-String $search | 
   Select-Object -First 1 | 
   Select-Object -ExpandProperty LineNumber

$data = $content[$line+26]
$check = "	scaled_spawn_chance = 8	# scales by galaxy size (1000 stars = 10x base)"
$check2 = "	scaled_spawn_chance = 9999	# scales by galaxy size (1000 stars = 10x base)"
if(($data -eq $check) -or ($data -eq $check2)){
Write-Host ">Dimensional Horror Leviathan"
Write-Host "0 - Skip"
Write-Host "1 - Guarantee Spawn"
Write-Host "2 - Vanilla Spawn Rate"
$choice = Read-Host "Please select an option"
if($choice -eq 1){
$content[$line+26] = '	scaled_spawn_chance = 9999	# scales by galaxy size (1000 stars = 10x base)'
$content | Set-Content -Path $file
Write-Host "Guaranteed Spawn: Dimensional Horror"
}
elseif($choice -eq 2){
$content[$line+26] = '	scaled_spawn_chance = 8	# scales by galaxy size (1000 stars = 10x base)'
$content | Set-Content -Path $file
Write-Host "Vanilla Spawn Rate: Dimensional Horror"
}
else{
    Write-Host "Skipped" -foregroundcolor "yellow"
}
}
else {
Write-Host "Guaranteed Spawn: Dimensional Horror - Unable to locate parameter. File may be edited by other mods, skipping" -foregroundcolor "yellow"
}

Write-Host "----------------------------------------"

#Automated Dreadnought
$search="# Automated Dreadnought"
$line  = Get-Content $file | 
   Select-String $search | 
   Select-Object -First 1 | 
   Select-Object -ExpandProperty LineNumber

$data = $content[$line+30]
$check = "	scaled_spawn_chance = 8	# scales by galaxy size (1000 stars = 10x base)"
$check2 = "	scaled_spawn_chance = 9999	# scales by galaxy size (1000 stars = 10x base)"
if(($data -eq $check) -or ($data -eq $check2)){
Write-Host ">Automated Dreadnought Leviathan"
Write-Host "0 - Skip"
Write-Host "1 - Guarantee Spawn"
Write-Host "2 - Vanilla Spawn Rate"
$choice = Read-Host "Please select an option"
if($choice -eq 1){
$content[$line+30] = '	scaled_spawn_chance = 9999	# scales by galaxy size (1000 stars = 10x base)'
$content | Set-Content -Path $file
Write-Host "Guaranteed Spawn: Automated Dreadnought"
}
elseif($choice -eq 2){
$content[$line+30] = '	scaled_spawn_chance = 8	# scales by galaxy size (1000 stars = 10x base)'
$content | Set-Content -Path $file
Write-Host "Vanilla Spawn Rate: Automated Dreadnought"
}
else{
    Write-Host "Skipped" -foregroundcolor "yellow"
}
}
else {
Write-Host "Guaranteed Spawn: Automated Dreadnought - Unable to locate parameter. File may be edited by other mods, skipping" -foregroundcolor "yellow"
}

Write-Host "----------------------------------------"

#Asteroid Hives
$search="# Hive"
$line  = Get-Content $file | 
   Select-String $search | 
   Select-Object -First 1 | 
   Select-Object -ExpandProperty LineNumber

$data = $content[$line+26]
$check = "	scaled_spawn_chance = 8	# scales by galaxy size (1000 stars = 10x base)"
$check2 = "	scaled_spawn_chance = 9999	# scales by galaxy size (1000 stars = 10x base)"
if(($data -eq $check) -or ($data -eq $check2)){
Write-Host ">Asteroid Hives"
Write-Host "0 - Skip"
Write-Host "1 - Guarantee Spawn"
Write-Host "2 - Vanilla Spawn Rate"
$choice = Read-Host "Please select an option"
if($choice -eq 1){
$content[$line+26] = '	scaled_spawn_chance = 9999	# scales by galaxy size (1000 stars = 10x base)'
$content | Set-Content -Path $file
Write-Host "Guaranteed Spawn: Asteroid Hives"
}
elseif($choice -eq 2){
$content[$line+26] = '	scaled_spawn_chance = 8	# scales by galaxy size (1000 stars = 10x base)'
$content | Set-Content -Path $file
Write-Host "Vanilla Spawn Rate: Asteroid Hives"
}
else{
    Write-Host "Skipped" -foregroundcolor "yellow"
}
}
else {
Write-Host "Guaranteed Spawn: Hive - Unable to locate parameter. File may be edited by other mods, skipping" -foregroundcolor "yellow"
}

Write-Host "----------------------------------------"

#Infinity Machine
$search="#Technosphere"
$line  = Get-Content $file | 
   Select-String $search | 
   Select-Object -First 1 | 
   Select-Object -ExpandProperty LineNumber

$data = $content[$line+20]
$check = "	scaled_spawn_chance = 8	# scales by galaxy size (1000 stars = 10x base)"
$check2 = "	scaled_spawn_chance = 9999	# scales by galaxy size (1000 stars = 10x base)"
if(($data -eq $check) -or ($data -eq $check2)){
Write-Host ">Infinity Machine Leviathan"
Write-Host "0 - Skip"
Write-Host "1 - Guarantee Spawn"
Write-Host "2 - Vanilla Spawn Rate"
$choice = Read-Host "Please select an option"
if($choice -eq 1){
$content[$line+20] = '	scaled_spawn_chance = 9999	# scales by galaxy size (1000 stars = 10x base)'
$content | Set-Content -Path $file
Write-Host "Guaranteed Spawn: Infinity Machine"
}
elseif($choice -eq 2){
$content[$line+20] = '	scaled_spawn_chance = 8	# scales by galaxy size (1000 stars = 10x base)'
$content | Set-Content -Path $file
Write-Host "Vanilla Spawn Rate: Infinity Machine"
}
else{
    Write-Host "Skipped" -foregroundcolor "yellow"
}
}
else {
Write-Host "Guaranteed Spawn: Infinity Machine - Unable to locate parameter. File may be edited by other mods, skipping" -foregroundcolor "yellow"
}

Write-Host "----------------------------------------"

#Enigmatic Fortress
$search="### Enigmatic Fortress"
$line  = Get-Content $file | 
   Select-String $search | 
   Select-Object -First 1 | 
   Select-Object -ExpandProperty LineNumber

$data = $content[$line+24]
$check = "	scaled_spawn_chance = 8	# scales by galaxy size (1000 stars = 10x base)"
$check2 = "	scaled_spawn_chance = 9999	# scales by galaxy size (1000 stars = 10x base)"
if(($data -eq $check) -or ($data -eq $check2)){
Write-Host ">Enigmatic Fortress Leviathan"
Write-Host "0 - Skip"
Write-Host "1 - Guarantee Spawn"
Write-Host "2 - Vanilla Spawn Rate"
$choice = Read-Host "Please select an option"
if($choice -eq 1){
$content[$line+24] = '	scaled_spawn_chance = 9999	# scales by galaxy size (1000 stars = 10x base)'
$content | Set-Content -Path $file
Write-Host "Guaranteed Spawn: Enigmatic Fortress"
}
elseif($choice -eq 2){
$content[$line+24] = '	scaled_spawn_chance = 8	# scales by galaxy size (1000 stars = 10x base)'
$content | Set-Content -Path $file
Write-Host "Vanilla Spawn Rate: Enigmatic Fortress"
}
else{
    Write-Host "Skipped" -foregroundcolor "yellow"
}
}
else {
Write-Host "Guaranteed Spawn: Enigmatic Fortress - Unable to locate parameter. File may be edited by other mods, skipping" -foregroundcolor "yellow"
}

Write-Host "----------------------------------------"

#Wraith
$search="# Wraith"
$line  = Get-Content $file | 
   Select-String $search | 
   Select-Object -First 1 | 
   Select-Object -ExpandProperty LineNumber

$data = $content[$line+20]
$check = "	scaled_spawn_chance = 8	# scales by galaxy size (1000 stars = 10x base)"
$check2 = "	scaled_spawn_chance = 9999	# scales by galaxy size (1000 stars = 10x base)"
if(($data -eq $check) -or ($data -eq $check2)){
Write-Host ">Spectral Wraith Leviathan"
Write-Host "0 - Skip"
Write-Host "1 - Guarantee Spawn"
Write-Host "2 - Vanilla Spawn Rate"
$choice = Read-Host "Please select an option"
if($choice -eq 1){
$content[$line+20] = '	scaled_spawn_chance = 9999	# scales by galaxy size (1000 stars = 10x base)'
$content | Set-Content -Path $file
Write-Host "Guaranteed Spawn: Spectral Wraith"
}
elseif($choice -eq 2){
$content[$line+20] = '	scaled_spawn_chance = 8	# scales by galaxy size (1000 stars = 10x base)'
$content | Set-Content -Path $file
Write-Host "Vanilla Spawn Rate: Spectral Wraith"
}
else{
    Write-Host "Skipped" -foregroundcolor "yellow"
}
}
else {
Write-Host "Guaranteed Spawn: Spectral Wraith - Unable to locate parameter. File may be edited by other mods, skipping" -foregroundcolor "yellow"
}


}
else {
    Write-Host "DLC not detected, skipping." -foregroundcolor "yellow"
}



Write-Host "----------------------------------------"
Write-Host ">Distant Stars Story Pack:"
if($dlc_diststars){
$file = "common\solar_system_initializers\distant_stars_initializers.txt"
$content = Get-Content -Path $file
#Voidspawn


$search="####### HATCHLING/VOIDSPAWN SYSTEM ######"
$line  = Get-Content $file | 
   Select-String $search | 
   Select-Object -First 1 | 
   Select-Object -ExpandProperty LineNumber

$data = $content[$line+26]
$check = "	scaled_spawn_chance = 8	# scales by galaxy size (1000 stars = 10x base)"
$check2 = "	scaled_spawn_chance = 9999	# scales by galaxy size (1000 stars = 10x base)"
if(($data -eq $check) -or ($data -eq $check2)){
Write-Host ">Voidspawn Leviathan"
Write-Host "0 - Skip"
Write-Host "1 - Guarantee Spawn"
Write-Host "2 - Vanilla Spawn Rate"
$choice = Read-Host "Please select an option"
if($choice -eq 1){
$content[$line+26] = '	scaled_spawn_chance = 9999	# scales by galaxy size (1000 stars = 10x base)'
$content | Set-Content -Path $file
Write-Host "Guaranteed Spawn: Voidspawn"
}
elseif($choice -eq 2){
$content[$line+26] = '	scaled_spawn_chance = 8	# scales by galaxy size (1000 stars = 10x base)'
$content | Set-Content -Path $file
Write-Host "Vanilla Spawn Rate: Voidspawn"
}
else{
    Write-Host "Skipped" -foregroundcolor "yellow"
}
}
else {
Write-Host "Guaranteed Spawn: Voidspawn - Unable to locate parameter. File may be edited by other mods, skipping" -foregroundcolor "yellow"
}

Write-Host "----------------------------------------"

#Scavenger Bot
$search="# Scavenger Bot System"
$line  = Get-Content $file | 
   Select-String $search | 
   Select-Object -First 1 | 
   Select-Object -ExpandProperty LineNumber

$data = $content[$line+27]
$check = "	scaled_spawn_chance = 8"
$check2 = "	scaled_spawn_chance = 9999"
if(($data -eq $check) -or ($data -eq $check2)){
Write-Host ">Scavenger Bot Leviathan"
Write-Host "0 - Skip"
Write-Host "1 - Guarantee Spawn"
Write-Host "2 - Vanilla Spawn Rate"
$choice = Read-Host "Please select an option"
if($choice -eq 1){
$content[$line+27] = '	scaled_spawn_chance = 9999'
$content | Set-Content -Path $file
Write-Host "Guaranteed Spawn: Scavenger Bot"
}
elseif($choice -eq 2){
$content[$line+27] = '	scaled_spawn_chance = 8'
$content | Set-Content -Path $file
Write-Host "Vanilla Spawn Rate: Scavenger Bot"
}
else{
    Write-Host "Skipped" -foregroundcolor "yellow"
}
}
else {
Write-Host "Guaranteed Spawn: Scavenger Bot - Unable to locate parameter. File may be edited by other mods, skipping" -foregroundcolor "yellow"
}

}
else {
    Write-Host "DLC not detected, skipping." -foregroundcolor "yellow"
}



Write-Host "----------------------------------------"
Write-Host "########################################"
Write-Host "##### Patching Federation Defaults #####"
Write-Host "----------------------------------------"
Write-Host ">Base Game:"
$file = "common\federation_types\00_federation_types.txt"
$content = Get-Content -Path $file
# Galactic Union
$search="default_federation = {"
$line  = Get-Content $file | 
   Select-String $search | 
   Select-Object -First 1 | 
   Select-Object -ExpandProperty LineNumber

$data = $content[$line+69]
$check = "#		 set_federation_law = allow_subjects_to_join_no"
$check2 = "		set_federation_law = allow_subjects_to_join_no"
if(($data -eq $check) -or ($data -eq $check2)){
Write-Host ">Allow Subjects to join on Galactic Union Formation?"
Write-Host "0 - Skip"
Write-Host "1 - Prevent (Vanilla)"
Write-Host "2 - Allow"
$choice = Read-Host "Please select an option"
if($choice -eq 1){
$content[$line+69] = '		set_federation_law = allow_subjects_to_join_no'
$content | Set-Content -Path $file
Write-Host "Disabled Subjects joining as default on federation creation: Galactic Union"
}
elseif($choice -eq 2){
$content[$line+69] = "#		 set_federation_law = allow_subjects_to_join_no"
$content | Set-Content -Path $file
Write-Host "Enabled Subjects joining as default on federation creation: Galactic Union"
}
else{
    Write-Host "Skipped" -foregroundcolor "yellow"
}
}
else {
Write-Host "Galactic Union, disable subjects joining by default - Unable to locate parameter. File may be edited by other mods, skipping" -foregroundcolor "yellow"
}



Write-Host "----------------------------------------"
Write-Host ">Federations Expansion:"
if($dlc_federations){

# Trade League
$search="trade_federation = {"
$line  = Get-Content $file | 
   Select-String $search | 
   Select-Object -First 1 | 
   Select-Object -ExpandProperty LineNumber

$data = $content[$line+90]
$check = "#		 set_federation_law = allow_subjects_to_join_no"
$check2 = "		set_federation_law = allow_subjects_to_join_no"
if(($data -eq $check) -or ($data -eq $check2)){
    Write-Host ">Allow Subjects to join on Trade League Formation?"
    Write-Host "0 - Skip"
    Write-Host "1 - Prevent (Vanilla)"
    Write-Host "2 - Allow"
$choice = Read-Host "Please select an option"
if($choice -eq 1){
$content[$line+90] = '		set_federation_law = allow_subjects_to_join_no'
$content | Set-Content -Path $file
Write-Host "Disabled Subjects joining as default on federation creation: Trade League"
}
elseif($choice -eq 2){
$content[$line+90] = "#		 set_federation_law = allow_subjects_to_join_no"
$content | Set-Content -Path $file
Write-Host "Enabled Subjects joining as default on federation creation: Trade League"
}
else{
    Write-Host "Skipped" -foregroundcolor "yellow"
}
}
else {
Write-Host "Trade League, disable subjects joining by default - Unable to locate parameter. File may be edited by other mods, skipping" -foregroundcolor "yellow"
}

Write-Host "----------------------------------------"

# Research Cooperative
$search="research_federation = {"
$line  = Get-Content $file | 
   Select-String $search | 
   Select-Object -First 1 | 
   Select-Object -ExpandProperty LineNumber

$data = $content[$line+80]
$check = "#		 set_federation_law = allow_subjects_to_join_no"
$check2 = "		set_federation_law = allow_subjects_to_join_no"
if(($data -eq $check) -or ($data -eq $check2)){
    Write-Host ">Allow Subjects to join on Research Cooperative Formation?"
    Write-Host "0 - Skip"
    Write-Host "1 - Prevent (Vanilla)"
    Write-Host "2 - Allow"
$choice = Read-Host "Please select an option"
if($choice -eq 1){
$content[$line+80] = '		set_federation_law = allow_subjects_to_join_no'
$content | Set-Content -Path $file
Write-Host "Disabled Subjects joining as default on federation creation: Research Cooperative"
}
elseif($choice -eq 2){
$content[$line+80] = "#		 set_federation_law = allow_subjects_to_join_no"
$content | Set-Content -Path $file
Write-Host "Enabled Subjects joining as default on federation creation: Research Cooperative"
}
else{
    Write-Host "Skipped" -foregroundcolor "yellow"
}
}
else {
Write-Host "Research Cooperative, disable subjects joining by default - Unable to locate parameter. File may be edited by other mods, skipping" -foregroundcolor "yellow"
}

Write-Host "----------------------------------------"

# Holy Covenant
$search="spiritualist_federation = {"
$line  = Get-Content $file | 
   Select-String $search | 
   Select-Object -First 1 | 
   Select-Object -ExpandProperty LineNumber

$data = $content[$line+81]
$check = "#		 set_federation_law = allow_subjects_to_join_no"
$check2 = "		set_federation_law = allow_subjects_to_join_no"
if(($data -eq $check) -or ($data -eq $check2)){
    Write-Host ">Allow Subjects to join on Holy Covenant Formation?"
    Write-Host "0 - Skip"
    Write-Host "1 - Prevent (Vanilla)"
    Write-Host "2 - Allow"
$choice = Read-Host "Please select an option"
if($choice -eq 1){
$content[$line+81] = '		set_federation_law = allow_subjects_to_join_no'
$content | Set-Content -Path $file
Write-Host "Disabled Subjects joining as default on federation creation: Holy Covenant"
}
elseif($choice -eq 2){
$content[$line+81] = "#		 set_federation_law = allow_subjects_to_join_no"
$content | Set-Content -Path $file
Write-Host "Enabled Subjects joining as default on federation creation: Holy Covenant"
}
else{
    Write-Host "Skipped" -foregroundcolor "yellow"
}
}
else {
Write-Host "Holy Covenant, disable subjects joining by default - Unable to locate parameter. File may be edited by other mods, skipping" -foregroundcolor "yellow"
}

Write-Host "----------------------------------------"

# Martial Alliance 
$search="military_federation = {"
$line  = Get-Content $file | 
   Select-String $search | 
   Select-Object -First 1 | 
   Select-Object -ExpandProperty LineNumber

$data = $content[$line+75]
$check = "#		 set_federation_law = allow_subjects_to_join_no"
$check2 = "		set_federation_law = allow_subjects_to_join_no"
if(($data -eq $check) -or ($data -eq $check2)){
    Write-Host ">Allow Subjects to join on Martial Alliance Formation?"
    Write-Host "0 - Skip"
    Write-Host "1 - Prevent (Vanilla)"
    Write-Host "2 - Allow"
$choice = Read-Host "Please select an option"
if($choice -eq 1){
$content[$line+75] = '		set_federation_law = allow_subjects_to_join_no'
$content | Set-Content -Path $file
Write-Host "Disabled Subjects joining as default on federation creation: Martial Alliance"
}
elseif($choice -eq 2){
$content[$line+75] = "#		 set_federation_law = allow_subjects_to_join_no"
$content | Set-Content -Path $file
Write-Host "Enabled Subjects joining as default on federation creation: Martial Alliance"
}
else{
    Write-Host "Skipped" -foregroundcolor "yellow"
}
}
else {
Write-Host "Martial Alliance, disable subjects joining by default - Unable to locate parameter. File may be edited by other mods, skipping" -foregroundcolor "yellow"
}

Write-Host "----------------------------------------"

# Hegemony
$search="hegemony_federation = {"
$line  = Get-Content $file | 
   Select-String $search | 
   Select-Object -First 1 | 
   Select-Object -ExpandProperty LineNumber

$data = $content[$line+78]
$check = "	}"
$check2 = "set_federation_law = allow_subjects_to_join_no }"
if(($data -eq $check) -or ($data -eq $check2)){
    Write-Host ">Allow Subjects to join on Hegemony Formation?"
    Write-Host "0 - Skip"
    Write-Host "1 - Prevent"
    Write-Host "2 - Allow (Vanilla)"
$choice = Read-Host "Please select an option"
if($choice -eq 1){
$content[$line+78] = 'set_federation_law = allow_subjects_to_join_no }'
$content | Set-Content -Path $file
Write-Host "Disabled Subjects joining as default on federation creation: Hegemony"
}
elseif($choice -eq 2){
$content[$line+78] = "	}"
$content | Set-Content -Path $file
Write-Host "Enabled Subjects joining as default on federation creation: Hegemony"
}
else{
    Write-Host "Skipped" -foregroundcolor "yellow"
}
}
else {
Write-Host "Hegemony, disable subjects joining by default - Unable to locate parameter. File may be edited by other mods, skipping" -foregroundcolor "yellow"
}

}
else {
    Write-Host "DLC not detected, skipping." -foregroundcolor "yellow"
}

Write-Host "----------------------------------------"
Write-Host "########################################"
Write-Host "####### Patching Empire Defaults #######"
Write-Host "----------------------------------------"

$file = "common\defines\00_defines.txt"
$content = Get-Content -Path $file

#Base Envoys

$search="		RELIC_VIEW_DEFAULT_ROW_COUNT = 2"
$line  = Get-Content $file | 
   Select-String $search | 
   Select-Object -First 1 | 
   Select-Object -ExpandProperty LineNumber

$data = $content[$line+3]
# This isn't checked, so be strict on what can be entered here

Write-Host ">Empire Base Number of Envoys:"
Write-Host ">Vanilla = 2"
$choice = Read-Host "Please select a number (0-99)"
if(($choice -ge 0) -and ($choice -le 99)){
$content[$line+3] = '		BASE_ENVOYS_REGULAR_EMPIRE = '+$choice
$content | Set-Content -Path $file
Write-Host "Set default base envoys: "$choice
}

else{
    Write-Host "Invalid Input, skipped" -foregroundcolor "yellow"
}
Write-Host "----------------------------------------"
Write-Host ">Empire Default Number of Megastructures that can be built simultaneously:"
Write-Host ">Vanilla = 1"
$choice = Read-Host "Please select a number (0-99)"
if(($choice -ge 0) -and ($choice -le 99)){
$content[$line+1] = '		MEGASTRUCTURE_BUILD_CAP_BASE = '+$choice
$content | Set-Content -Path $file
Write-Host "Set default base buildable megastructures: "$choice
}

else{
    Write-Host "Invalid Input, skipped" -foregroundcolor "yellow"
}

Write-Host "----------------------------------------"
Write-Host ">Utopia Expansion:"
if($dlc_utopia){

$file = "common\technology\00_eng_tech.txt"
$content = Get-Content -Path $file

$search="tech_habitat_1 = {"
$line  = Get-Content $file | 
   Select-String $search | 
   Select-Object -First 1 | 
   Select-Object -ExpandProperty LineNumber

$data = $content[$line+63]
$check = "	ai_weight = {"
$check2 = "	ai_weight = { weight = 0"
if(($data -eq $check) -or ($data -eq $check2)){
    Write-Host ">Allow AI to research Habitats?"
    Write-Host "0 - Skip"
    Write-Host "1 - Prevent"
    Write-Host "2 - Allow (Vanilla)"
$choice = Read-Host "Please select an option"
if($choice -eq 1){
$content[$line+63] = '	ai_weight = { weight = 0'
$content | Set-Content -Path $file
Write-Host ""
}
elseif($choice -eq 2){
$content[$line+63] = "	ai_weight = {"
$content | Set-Content -Path $file
Write-Host ""
}
else{
    Write-Host "Skipped" -foregroundcolor "yellow"
}
}
else {
Write-Host "Allow AI to research Habitats - Unable to locate parameter. File may be edited by other mods, skipping" -foregroundcolor "yellow"
}
}
else {
    Write-Host "DLC not detected, skipping." -foregroundcolor "yellow"
}

Write-Host "----------------------------------------"
Write-Host "########################################"
Write-Host "### Patching L-Cluster Spawning Odds ###"
Write-Host "----------------------------------------"
Write-Host ">Distant Stars Story Pack:"
if($dlc_diststars){
$file = "events\distant_stars_events_3.txt"
$content = Get-Content -Path $file

# Do the verification check here first.  It's a bit janky and less robust, but should (hopefully) work well enough!

$search="# Randomize L-Cluster outcome on_game_start"
$line  = Get-Content $file | 
   Select-String $search | 
   Select-Object -First 1 | 
   Select-Object -ExpandProperty LineNumber

$data = $content[$line+10]
$data2 = $content[$line+29]
$check = "			random_list = {"
$check2 = "}"
if((($data -eq $check) -or ($data -eq $check2)) -and ($data2 -eq $check2)){

Write-Host ">Guarantee L-Cluster Result"
Write-Host ">Options:"
Write-Host "0 - Skip"
Write-Host "1 - Grey Tempest"
Write-Host "2 - L-Drake"
Write-Host "3 - Dessanu Consonance"
Write-Host "4 - Empty/Grey"
Write-Host "5 - Anything EXCEPT the Grey Tempest"
Write-Host "6 - Vanilla odds"

$choice = Read-Host "Please select an option"

if ($choice -eq 0){Write-Host "Skipping!" -foregroundcolor "yellow"}
elseif ($choice -eq 1){

    $content[$line+11] = '				1 = {' # Grey Tempest
    $content[$line+19] = '				0 = {}'# Grey
    $content[$line+20] = '				0 = {' # Drakes
    $content[$line+23] = '				0 = {' # Dessanu Consonance
    $content | Set-Content -Path $file
    Write-Host "Guarantee L-Cluster Result: Grey Tempest"
}
elseif ($choice -eq 2){

    $content[$line+11] = '				0 = {' # Grey Tempest
    $content[$line+19] = '				0 = {}'# Grey
    $content[$line+20] = '				1 = {' # Drakes
    $content[$line+23] = '				0 = {' # Dessanu Consonance
    $content | Set-Content -Path $file
    Write-Host "Guarantee L-Cluster Result: L-Drakes"
}
elseif ($choice -eq 3){

    $content[$line+11] = '				0 = {' # Grey Tempest
    $content[$line+19] = '				0 = {}'# Grey
    $content[$line+20] = '				0 = {' # Drakes
    $content[$line+23] = '				1 = {' # Dessanu Consonance
    $content | Set-Content -Path $file
    Write-Host "Guarantee L-Cluster Result: Dessanu Consonance"
}
elseif ($choice -eq 4){

    $content[$line+11] = '				0 = {' # Grey Tempest
    $content[$line+19] = '				1 = {}'# Grey
    $content[$line+20] = '				0 = {' # Drakes
    $content[$line+23] = '				0 = {' # Dessanu Consonance
    $content | Set-Content -Path $file
    Write-Host "Guarantee L-Cluster Result: Empty/Grey"
}
elseif ($choice -eq 5){

    $content[$line+11] = '				0 = {' # Grey Tempest
    $content[$line+19] = '				1 = {}'# Grey
    $content[$line+20] = '				1 = {' # Drakes
    $content[$line+23] = '				1 = {' # Dessanu Consonance
    $content | Set-Content -Path $file
    Write-Host "Guarantee L-Cluster Result: Anything EXCEPT Grey Tempest"
}
elseif ($choice -eq 6){

    $content[$line+11] = '				50 = {' # Grey Tempest
    $content[$line+19] = '				30 = {}'# Grey
    $content[$line+20] = '				30 = {' # Drakes
    $content[$line+23] = '				30 = {' # Dessanu Consonance
    $content | Set-Content -Path $file
    Write-Host "Guarantee L-Cluster Result: Vanilla odds"
}
else {write-host "Invalid option selected, skipping!"-foregroundcolor "yellow"}
}
else {
Write-Host "L-Cluster Result - Unable to locate parameter. File may be edited by other mods, skipping" -foregroundcolor "yellow"
}
}
else {
    Write-Host "DLC not detected, skipping." -foregroundcolor "yellow"
}

Write-Host "----------------------------------------"
Write-Host "########################################"
Write-Host "########## Updates Complete! ###########"
Write-Host "########################################"

pause
exit
}


# Restore Backups

elseif($mode -eq 2){

    if(test-path $mod_path\backups\00_federation_types.txt){
    Copy-Item -Path $mod_path\backups\00_federation_types.txt -Destination $stel_path\common\federation_types
    Write-Host ">Restored 00_federation_types.txt" -foregroundcolor "green"}
    else {Write-Host ">Unable to restore 00_federation_types.txt - backup not found!" -foregroundcolor "red"}

    if(test-path $mod_path\backups\00_on_actions.txt){
    Copy-Item -Path $mod_path\backups\00_on_actions.txt -Destination $stel_path\common\on_actions
    Write-Host ">Restored 00_on_actions.txt" -foregroundcolor "green"}
    else {Write-Host ">Unable to restore 00_on_actions.txt - backup not found!" -foregroundcolor "red"}
    
    if(test-path $mod_path\backups\distant_stars_initializers.txt){
    Copy-Item -Path $mod_path\backups\distant_stars_initializers.txt -Destination $stel_path\common\solar_system_initializers
    Write-Host ">Restored distant_stars_initializers.txt" -foregroundcolor "green"}
    else {Write-Host ">Unable to restore distant_stars_initializers.txt - backup not found!" -foregroundcolor "red"}
    
    if(test-path $mod_path\backups\leviathans_system_initializers.txt){
    Copy-Item -Path $mod_path\backups\leviathans_system_initializers.txt -Destination $stel_path\common\solar_system_initializers
    Write-Host ">Restored leviathans_system_initializers.txt" -foregroundcolor "green"}
    else {Write-Host ">Unable to restore leviathans_system_initializers.txt - backup not found!" -foregroundcolor "red"}
    
    if(test-path $mod_path\backups\pre_ftl_initializers.txt){
    Copy-Item -Path $mod_path\backups\pre_ftl_initializers.txt -Destination $stel_path\common\solar_system_initializers
    Write-Host ">Restored pre_ftl_initializers.txt" -foregroundcolor "green"}
    else {Write-Host ">Unable to restore pre_ftl_initializers.txt - backup not found!" -foregroundcolor "red"}

    if(test-path $mod_path\backups\ancient_relics_arcsite_events_2.txt){
    Copy-Item -Path $mod_path\backups\ancient_relics_arcsite_events_2.txt -Destination $stel_path\events
    Write-Host ">Restored ancient_relics_arcsite_events_2.txt" -foregroundcolor "green"}
    else {Write-Host ">Unable to restore ancient_relics_arcsite_events_2.txt - backup not found!" -foregroundcolor "red"}

    if(test-path $mod_path\backups\central_crystal_events.txt){
    Copy-Item -Path $mod_path\backups\central_crystal_events.txt -Destination $stel_path\events
    Write-Host ">Restored central_crystal_events.txt" -foregroundcolor "green"}
    else {Write-Host ">Unable to restore central_crystal_events.txt - backup not found!" -foregroundcolor "red"}
    
    if(test-path $mod_path\backups\distant_stars_events_3.txt){
    Copy-Item -Path $mod_path\backups\distant_stars_events_3.txt -Destination $stel_path\events
    Write-Host ">Restored distant_stars_events_3.txt" -foregroundcolor "green"}
    else {Write-Host ">Unable to restore distant_stars_events_3.txt - backup not found!" -foregroundcolor "red"}

    if(test-path $mod_path\backups\utopia_shroud_events.txt){
    Copy-Item -Path $mod_path\backups\utopia_shroud_events.txt -Destination $stel_path\events
    Write-Host ">Restored utopia_shroud_events.txt" -foregroundcolor "green"}
    else {Write-Host ">Unable to restore utopia_shroud_events.txt - backup not found!" -foregroundcolor "red"}

    if(test-path $mod_path\backups\fallen_empire_awakening_events.txt){
    Copy-Item -Path $mod_path\backups\fallen_empire_awakening_events.txt -Destination $stel_path\events
    Write-Host ">Restored utopia_shroud_events.txt" -foregroundcolor "green"}
    else {Write-Host ">Unable to restore utopia_shroud_events.txt - backup not found!" -foregroundcolor "red"}
        
    if(test-path $mod_path\backups\00_defines.txt){
    Copy-Item -Path $mod_path\backups\00_defines.txt -Destination $stel_path\common\defines
    Write-Host ">Restored 00_defines.txt" -foregroundcolor "green"}
    else {Write-Host ">Unable to restore 00_defines.txt - backup not found!" -foregroundcolor "red"}
        
    if(test-path $mod_path\backups\marauder_events.txt){
    Copy-Item -Path $mod_path\backups\marauder_events.txt -Destination $stel_path\events
    Write-Host ">Restored marauder_events.txt" -foregroundcolor "green"}
    else {Write-Host ">Unable to restore marauder_events.txt - backup not found!" -foregroundcolor "red"}    

    if(test-path $mod_path\backups\caravaneer_events.txt){
    Copy-Item -Path $mod_path\backups\caravaneer_events.txt -Destination $stel_path\events
    Write-Host ">Restored caravaneer_events.txt" -foregroundcolor "green"}
    else {Write-Host ">Unable to restore caravaneer_events.txt - backup not found!" -foregroundcolor "red"}        
    
    if(test-path $mod_path\backups\00_eng_tech.txt){
    Copy-Item -Path $mod_path\backups\00_eng_tech.txt -Destination $stel_path\common\technology
    Write-Host ">Restored caravaneer_events.txt" -foregroundcolor "green"}
    else {Write-Host ">Unable to restore caravaneer_events.txt - backup not found!" -foregroundcolor "red"}   

    Write-Host "Restoration complete!"
    pause
    exit

}

elseif($mode -eq 3){
    exit
}

else{
    Write-Host "Invalid option selected, exiting!" -foregroundcolor "yellow"
    pause
    exit
}