#SingleInstance force    ; Override existing instance when lauched again
Persistent    ; Keep the application alive
SetWorkingDir(A_ScriptDir)    ; Ensures a consistent working directory (script folder)

#Include MenuManager.ahk
#Include core.ahk

fileInstall("..\resources\ScreenSketch.ico", "ScreenSketch.ico", true)
fileInstall("..\scripts\gitUpdateAll.ps1.bat", "gitUpdateAll.ps1.bat", true)
fileInstall("..\scripts\wingetUpdateAll.ps1.bat", "wingetUpdateAll.ps1.bat", true)

tray := MenuManager(&TRAYMENU_LAYOUT)

return