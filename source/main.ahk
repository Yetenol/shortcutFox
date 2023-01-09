#SingleInstance force    ; Override existing instance when lauched again
Persistent    ; Keep the application alive
SetWorkingDir(A_ScriptDir)    ; Ensures a consistent working directory (script folder)

#Include config/config.ahk
#Include config/includeResources.ahk
#Include config/keyboardShortcuts.ahk
#Include trayMenu.ahk

; Create tray menu
tray := MenuManager()
restoreSuspendState()

restoreSuspendState() {
    if readSetting("SUSPEND") {
        Suspend
    }
}

return