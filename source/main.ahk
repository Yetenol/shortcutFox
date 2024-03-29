#SingleInstance force    ; Override existing instance when launched again
Persistent    ; Keep the application alive
SetWorkingDir(A_ScriptDir)    ; Ensures a consistent working directory (script folder)

#Include installation.ahk
#Include config/config.ahk
#Include config/includeResources.ahk
#Include config/keyboardShortcuts.ahk
#Include trayMenu.ahk
#Include MenuManager.ahk

; Create tray menu
tray := MenuBuilder()
restoreSuspendState()

restoreSuspendState() {
    if readSetting("SUSPEND") {
        Suspend
    }
}

return