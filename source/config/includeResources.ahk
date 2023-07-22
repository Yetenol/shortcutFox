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
FileInstall("icons\wallpaper.ico", "icons\wallpaper.ico", true)

FileInstall("icons\fingerprint.png", "icons\fingerprint.png", true)
FileInstall("icons\add-fingerprint.png", "icons\add-fingerprint.png", true)
FileInstall("icons\bluetooth.png", "icons\bluetooth.png", true)
FileInstall("icons\checked-checkbox.png", "icons\checked-checkbox.png", true)
FileInstall("icons\face-recognition.png", "icons\face-recognition.png", true)
FileInstall("icons\filled-circle.png", "icons\filled-circle.png", true)
FileInstall("icons\git-compare.png", "icons\git-compare.png", true)
FileInstall("icons\git-fork.png", "icons\git-fork.png", true)
FileInstall("icons\pen.png", "icons\pen.png", true)
FileInstall("icons\scan-fingerprint.png", "icons\scan-fingerprint.png", true)
FileInstall("icons\screenshot.png", "icons\screenshot.png", true)
FileInstall("icons\software (2).png", "icons\software (2).png", true)
FileInstall("icons\software.png", "icons\software.png", true)
FileInstall("icons\unchecked-checkbox.png", "icons\unchecked-checkbox.png", true)
FileInstall("icons\unfilled-circle.png", "icons\unfilled-circle.png", true)
FileInstall("icons\wallpaper.png", "icons\wallpaper.png", true)

FileInstall("scripts\gitUpdateAll.ps1", "scripts\gitUpdateAll.ps1", true)
FileInstall("scripts\wingetUpdateAll.ps1", "scripts\wingetUpdateAll.ps1", true)
FileInstall("scripts\applyRedditWallpaper.ps1", "scripts\applyRedditWallpaper.ps1", true)