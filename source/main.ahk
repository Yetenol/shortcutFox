#SingleInstance force ; Override existing instance when lauched again
Persistent ; Keep the application alive
#Include menu.ahk
SetWorkingDir(A_ScriptDir) ; Ensures a consistent working directory (script folder)

tray := TrayMenu()