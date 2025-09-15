#Usuwanie wszystkich plików z pendrive'a oprócz skryptów
Get-ChildItem "..\API\" | Where-Object { 
    $_.Name -ne "winget.ps1" -and 
    $_.Name -ne "uruchom_winget.bat"
    #pliki do zachowania dodawać powyżej według wzoru -and 
    #$_.Name -ne "nazwa_pliku"
} | Remove-Item -Recurse

#Instalacja 7-Zip
winget install 7zip.7zip --accept-source-agreements --accept-package-agreements

#Rozszerzenia ALL USERS
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
"HKLM:\Software\Classes\7-Zip.$($extensions[$i])", #ALL USERS
"HKCU:\Software\Classes\7-Zip.$($extensions[$i])" #ADMINISTRATOR
)
    for ($j = 0; $j -lt 2; $j++){
    if($extensions[$i] -eq "iso" -or $extensions[$i] -eq "vhd" -or $extensions[$i] -eq "vhdx"){$j++}
        New-Item -Path $sevenZipPath[$j] -Force 
        Set-ItemProperty -Path $sevenZipPath[$j] -Name "(Default)" -Value "$($extensions[$i]) Archive"

        New-Item -Path "$($sevenZipPath[$j])\DefaultIcon" -Force
        Set-ItemProperty -Path "$($sevenZipPath[$j])\DefaultIcon" -Name "(Default)" -Value "C:\Program Files\7-Zip\7z.dll,$($iconMap[$extensions[$i]])" 

        New-Item -Path "$($sevenZipPath[$j])\shell\open\command" -Force
        Set-ItemProperty -Path "$($sevenZipPath[$j])\shell\open\command" -Name "(Default)" -Value '"C:\Program Files\7-Zip\7zFM.exe" "%1"'
        if($j -eq 1){
            New-Item -Path "HKCU:\Software\Classes\.$($extensions[$i])" -Force
            Set-ItemProperty -Path "HKCU:\Software\Classes\.$($extensions[$i])" -Name "(Default)" -Value "7-Zip.$($extensions[$i])"
        }
    }
    if($extensions[$i] -eq "iso" -or $extensions[$i] -eq "vhd" -or $extensions[$i] -eq "vhdx"){continue}
cmd /c "assoc .$($extensions[$i])=7-Zip.$($extensions[$i])"
cmd /c "ftype 7-Zip.$($extensions[$i])=`"C:\Program Files\7-Zip\7zFM.exe`" `"%1`""
}