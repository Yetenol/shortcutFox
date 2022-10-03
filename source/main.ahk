#SingleInstance force    ; Override existing instance when lauched again
Persistent    ; Keep the application alive
SetWorkingDir(A_ScriptDir)    ; Ensures a consistent working directory (script folder)

#Include trayMenu.ahk
#Include core.ahk

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

; Create tray menu
tray := MenuManager()

#!f:: {
    tray.clear()
}

#!u:: {
    tray.update()
}

#!l:: {
    tray.logAll()
}

return