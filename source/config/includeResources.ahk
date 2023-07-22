; Prepare resource folders
resourceFolders := "icons,scripts"
loop parse resourceFolders, "," {
    if DirExist(A_LoopField) {
        DirCreate A_LoopField
    }
}

; Install resource files
FileInstall("icons\bluetooth.png", "icons\bluetooth.png", true)
FileInstall("icons\checked-checkbox.png", "icons\checked-checkbox.png", true)
FileInstall("icons\face-recognition.png", "icons\face-recognition.png", true)
FileInstall("icons\filled-circle.png", "icons\filled-circle.png", true)
FileInstall("icons\fingerprint.png", "icons\fingerprint.png", true)
FileInstall("icons\git-compare.png", "icons\git-compare.png", true)
FileInstall("icons\menu.png", "icons\menu.png", true)
FileInstall("icons\pen.png", "icons\pen.png", true)
FileInstall("icons\screenshot.png", "icons\screenshot.png", true)
FileInstall("icons\software.png", "icons\software.png", true)
FileInstall("icons\unchecked-checkbox.png", "icons\unchecked-checkbox.png", true)
FileInstall("icons\unfilled-circle.png", "icons\unfilled-circle.png", true)
FileInstall("icons\wallpaper.png", "icons\wallpaper.png", true)


FileInstall("scripts\gitUpdateAll.ps1", "scripts\gitUpdateAll.ps1", true)
FileInstall("scripts\wingetUpdateAll.ps1", "scripts\wingetUpdateAll.ps1", true)
FileInstall("scripts\applyRedditWallpaper.ps1", "scripts\applyRedditWallpaper.ps1", true)