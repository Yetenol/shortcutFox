#Include config.ahk

; Toggle word case [CapsLock]
SetNumLockState True
SetCapsLockState "AlwaysOff"

; Change word case
#HotIf (
    WinActive("ahk_exe Code.exe") or
    WinActive("ahk_exe Obsidian.exe") or
    WinActive("ahk_exe Files.exe") or
    WinActive("ahk_exe WINWORD.EXE") or
    WinActive("ahk_exe POWERPNT.EXE")
) and readSetting("HOTKEY_TOGGLE_CASE")
CapsLock::
{
    SendInput "+{F3}"
}

; Focus or launch KeeWeb
#HotIf readSetting("HOTKEY_LAUNCH_KEEWEB")
#+V::
{
    global KEEWEB_BIN
    if not FileExist(KEEWEB_BIN) {
        return    ; KeeWeb not installed
    }

    if WinExist("ahk_exe KeeWeb.exe") {
        WinActivate("ahk_exe KeeWeb.exe")
    } else {
        Run KEEWEB_BIN
    }
}

#HotIf (
    WinActive("ahk_exe msedge.exe") and
    !WinExist("ahk_exe KeeWeb.exe")
) and readSetting("HOTKEY_PASTE_KEEWEB")
^+v::
{
    Run KEEWEB_BIN
}

#HotIf readSetting("HOTKEY_PASTE_DATE")
#!d:: {
    SendInput A_YYYY "-" A_MM "-" A_DD
}

; Cycle window in zone
#HotIf readSetting("HOTKEY_CYCLE_ZONE_WINDOW")
#WheelUp::
{
    SendInput "#{PgUp}"
}

#HotIf readSetting("HOTKEY_CYCLE_ZONE_WINDOW")
#WheelDown::
{
    SendInput "#{PgDn}"
}