#SingleInstance force ; Override existing instance when lauched again
Persistent ; Keep the application alive
SetWorkingDir(A_ScriptDir) ; Ensures a consistent working directory (script folder)

#Include MenuManager.ahk
#Include core.ahk

FileInstall("ScreenSketch.ico", "ScreenSketch.ico", true)

tray := MenuManager(TRAYMENU_LAYOUT)

return


#f::
{
    tray.printAll()
}