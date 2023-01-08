; Prepare resource folders
resourceFolders := "icons,scripts"
loop parse resourceFolders, "," {
    if DirExist(A_LoopField) {
        DirCreate A_LoopField
    }
}

; Install resource files
FileInstall("icons\add-fingerprint.ico", "icons\add-fingerprint.ico", true)
FileInstall("icons\bluetooth.ico", "icons\bluetooth.ico", true)
FileInstall("icons\code-fork.ico", "icons\code-fork.ico", true)
FileInstall("icons\face-id.ico", "icons\face-id.ico", true)
FileInstall("icons\shortcut.ico", "icons\shortcut.ico", true)
FileInstall("icons\software-installer.ico", "icons\software-installer.ico", true)
FileInstall("icons\whiteboard.ico", "icons\whiteboard.ico", true)
FileInstall("icons\windows-snipping-tool.ico", "icons\windows-snipping-tool.ico", true)

FileInstall("scripts\gitUpdateAll.ps1", "scripts\gitUpdateAll.ps1", true)
FileInstall("scripts\wingetUpdateAll.ps1", "scripts\wingetUpdateAll.ps1", true)