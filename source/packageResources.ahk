; Prepare resource folders
resourceFolders := "icons,scripts"
loop parse resourceFolders, "," {
    if (DirExist(A_LoopField))
        DirDelete A_LoopField, true
    DirCreate A_LoopField
}

; Install resource files
FileInstall("..\icons\add-fingerprint.ico", "icons\add-fingerprint.ico")
FileInstall("..\icons\bluetooth.ico", "icons\bluetooth.ico")
FileInstall("..\icons\code-fork.ico", "icons\code-fork.ico")
FileInstall("..\icons\face-id.ico", "icons\face-id.ico")
FileInstall("..\icons\shortcut.ico", "icons\shortcut.ico")
FileInstall("..\icons\software-installer.ico", "icons\software-installer.ico")
FileInstall("..\icons\whiteboard.ico", "icons\whiteboard.ico")
FileInstall("..\icons\windows-snipping-tool.ico", "icons\windows-snipping-tool.ico")

FileInstall("..\scripts\gitUpdateAll.ps1.bat", "scripts\gitUpdateAll.ps1.bat")
FileInstall("..\scripts\wingetUpdateAll.ps1.bat", "scripts\wingetUpdateAll.ps1.bat")
FileInstall("..\scripts\toggleRunAtStartup.ps1.bat", "scripts\toggleRunAtStartup.ps1.bat")