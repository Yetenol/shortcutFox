#SingleInstance force    ; Override existing instance when lauched again
Persistent    ; Keep the application alive
SetWorkingDir(A_ScriptDir)    ; Ensures a consistent working directory (script folder)

#Include MenuManager.ahk
#Include core.ahk

; Install icons
if (DirExist("icons")) {
    DirDelete "icons", true
}
DirCreate "icons"
FileInstall("..\icons\ScreenSketch.ico", "icons\ScreenSketch.ico")

; Install scripts
if (DirExist("scripts")) {
    DirDelete "scripts", true
}
DirCreate "scripts"
FileInstall("..\scripts\gitUpdateAll.ps1.bat", "scripts\gitUpdateAll.ps1.bat")
FileInstall("..\scripts\wingetUpdateAll.ps1.bat", "scripts\wingetUpdateAll.ps1.bat")

; Construct tray menu
tray := MenuManager(&TRAYMENU_LAYOUT)

return