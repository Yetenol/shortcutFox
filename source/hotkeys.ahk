#Include config.ahk

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