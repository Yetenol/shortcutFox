; Prepare resource folders
resourceFolders := "icons,scripts"
loop parse resourceFolders, "," {
    if (DirExist(A_LoopField))
        DirDelete A_LoopField, true
    DirCreate A_LoopField
}

; Install resource files
FileInstall("..\icons\ScreenSketch.ico", "icons\ScreenSketch.ico")
FileInstall("..\scripts\gitUpdateAll.ps1.bat", "scripts\gitUpdateAll.ps1.bat")
FileInstall("..\scripts\wingetUpdateAll.ps1.bat", "scripts\wingetUpdateAll.ps1.bat")
FileInstall("..\scripts\toggleRunAtStartup.ps1.bat", "scripts\toggleRunAtStartup.ps1.bat")