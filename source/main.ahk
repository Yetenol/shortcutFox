#SingleInstance force    ; Override existing instance when lauched again
Persistent    ; Keep the application alive
SetWorkingDir(A_ScriptDir)    ; Ensures a consistent working directory (script folder)

#Include core.ahk
#Include packageResources.ahk
#Include hotkeys.ahk
#Include trayMenu.ahk

; Create tray menu
tray := MenuManager()

return