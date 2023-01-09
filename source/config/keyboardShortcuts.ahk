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
