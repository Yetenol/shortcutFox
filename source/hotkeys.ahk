#Include config/config.ahk

; Toggle word case [CapsLock]
SetNumLockState True
SetCapsLockState "AlwaysOff"
CapsLock::
{
    if WinActive("ahk_exe Code.exe") ||
        WinActive("ahk_exe Obsidian.exe") ||
        WinActive("ahk_exe Files.exe") ||
        WinActive("ahk_exe WINWORD.EXE") ||
        WinActive("ahk_exe POWERPNT.EXE")
    SendInput "+{F3}"
}


; Focus or launch KeeWeb [Win + Shift + V]
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

#WheelUp::
{
    SendInput "#{PgUp}"
}

#WheelDown::
{
    SendInput "#{PgDn}"
}
