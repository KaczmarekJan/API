#Usuwanie wszystkich plików z pendrive'a oprócz skryptów
Get-ChildItem "..\API\" | Where-Object { 
    $_.Name -ne "winget.ps1" -and 
    $_.Name -ne "uruchom_winget.bat"
    #pliki do zachowania dodawać powyżej według wzoru -and 
    #$_.Name -ne "nazwa_pliku"
} | Remove-Item -Recurse


#Otwieranie stron do pobrania aplikacji nieobsługiwanych przez winget
Start-Process "https://pl.libreoffice.org/pobieranie/stabilna/"
Start-Process "https://airsdk.harman.com/runtime"
Start-Process "https://get.adobe.com/reader/"
Start-Process "https://dappcdn.com/download/disc-burning/cdburnerxp"
Start-Process "https://www.java.com/en/download/manual.jsp"
Read-Host "Pobierz instalatory do folderu API, a nastepnie nacisnij Enter, aby kontynuowac..."


#Instalacja 7-Zip
winget install 7zip.7zip --accept-source-agreements --accept-package-agreements

#Rozszerzenia
$extensions = @(
"7z",
"zip",
"rar",
"001",
"cab",
"iso",
"xz",
"txz",
"lzma",
"tar",
"cpio",
"bz2",
"bzip2",
"tbz2",
"tbz",
"gz",
"gzip",
"tgz",
"tpz",
"zst",
"tzst",
"z",
"taz",
"lzh",
"lha",
"rpm",
"deb",
"arj",
"vhd",
"vhdx",
"wim",
"swm",
"esd",
"fat",
"ntfs",
"dmg",
"hfs",
"xar",
"squashfs",
"apfs"
)

#Mapa ikon
$iconMap = @{
"7z" = 0
"zip" = 1
"rar" = 3
"001" = 9
"cab" = 7
"iso" = 8
"xz" = 23
"txz" = 23
"lzma" = 16
"tar" = 13
"cpio" = 12
"bz2" = 2
"bzip2" = 2
"tbz2" = 2
"tbz" = 2
"gz" = 14
"gzip" = 14
"tgz" = 14
"tpz" = 14
"zst" = 26
"tzst" = 26
"z" = 5
"taz" = 5
"lzh" = 6
"lha" = 6
"rpm" = 10
"deb" = 11
"arj" = 4
"vhd" = 20
"vhdx" = 20
"wim" = 15
"swm" = 15
"esd" = 15
"fat" = 21
"ntfs" = 22
"dmg" = 17
"hfs" = 18
"xar" = 19
"squashfs" = 24
"apfs" = 25
}

for ($i = 0; $i -lt $extensions.Count; $i++) {
$sevenZipPath = @(
#ścieżki do wpisów rejestru
"HKLM:\Software\Classes\7-Zip.$($extensions[$i])", #ALL USERS
"HKCU:\Software\Classes\7-Zip.$($extensions[$i])" #ADMINISTRATOR
)
    for ($j = 0; $j -lt 2; $j++){
    if($extensions[$i] -eq "iso" -or $extensions[$i] -eq "vhd" -or $extensions[$i] -eq "vhdx"){$j++} #pomijanie wpisu dla iso, vhd, vhdx ALL USERS
        #Główny wpis
        New-Item -Path $sevenZipPath[$j] -Force 
        Set-ItemProperty -Path $sevenZipPath[$j] -Name "(Default)" -Value "$($extensions[$i]) Archive"

        #Dodanie ikony
        New-Item -Path "$($sevenZipPath[$j])\DefaultIcon" -Force
        Set-ItemProperty -Path "$($sevenZipPath[$j])\DefaultIcon" -Name "(Default)" -Value "C:\Program Files\7-Zip\7z.dll,$($iconMap[$extensions[$i]])" 

        #Odwołanie do aplikacji
        New-Item -Path "$($sevenZipPath[$j])\shell\open\command" -Force
        Set-ItemProperty -Path "$($sevenZipPath[$j])\shell\open\command" -Name "(Default)" -Value '"C:\Program Files\7-Zip\7zFM.exe" "%1"'
        if($j -eq 1){
            #dodanie wpisu do HKCKU Admina, takie jego assoc/ftype
            New-Item -Path "HKCU:\Software\Classes\.$($extensions[$i])" -Force
            Set-ItemProperty -Path "HKCU:\Software\Classes\.$($extensions[$i])" -Name "(Default)" -Value "7-Zip.$($extensions[$i])"
        }
    }
if($extensions[$i] -eq "iso" -or $extensions[$i] -eq "vhd" -or $extensions[$i] -eq "vhdx"){continue}
cmd /c "assoc .$($extensions[$i])=7-Zip.$($extensions[$i])" #dodanie wpisu do assoc
cmd /c "ftype 7-Zip.$($extensions[$i])=`"C:\Program Files\7-Zip\7zFM.exe`" `"%1`"" #dodanie wpisu do ftype
}


#Instalacja LibreOffice i Help Packa po polsku
Start-Process "cmd.exe" -ArgumentList '/c msiexec /i "LibreOffice_25.8.1_Win_x86-64.msi" ADDLOCAL=ALL REGISTER_ALL_MSO_TYPES=1 QUICKSTART=1 /qn' -Wait
Start-Process "cmd.exe" -ArgumentList '/c msiexec /i "LibreOffice_25.8.1_Win_x86-64_helppack_pl.msi" /qn' -Wait


#Instalacja Google Chrome
winget install --id Google.Chrome --silent --scope machine --accept-package-agreements --accept-source-agreements


#Instalacja Firefoxa
winget install --id Mozilla.Firefox --silent --scope machine --accept-package-agreements --accept-source-agreements


#Instalacja Javy 32 i 64 bit
Start-Process ".\jre-8u461-windows-x64.exe" -ArgumentList "/s" -Wait
Start-Process ".\jre-8u461-windows-i586.exe" -ArgumentList "/s" -Wait


#Instalacja Adobe Air
Start-Process cmd.exe -ArgumentList "/c AdobeAIR.exe -silent" -Wait


#Instalacja Adobe DC
Start-Process -FilePath "Reader_pl_install.exe" -ArgumentList "/sAll /rs /rps /norestart"


#Instalacja CDBurner XP
$CDBurnerXP = Read-Host "Czy zainstalowac CDBurner XP? (T/N)"
if($CDBurnerXP -eq "T" -or $CDBurnerXP -eq "t"){
    Start-Process -FilePath "cdbxp_setup_4.5.8.7128_x64_minimal.exe" -ArgumentList "/silent" -Wait
}


#Instalacja TightVNC
winget install --id GlavSoft.TightVNC --interactive --scope machine --accept-package-agreements --accept-source-agreements


#Instalacja TeamViewera
$TeamViewer = Read-Host "Czy zainstalowac TeamViewera? (T/N)"
if($TeamViewer -eq "T" -or $TeamViewer -eq "t"){
    winget install --id TeamViewer.TeamViewer --silent --scope machine --accept-package-agreements --accept-source-agreements
}#>
