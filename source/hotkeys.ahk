#Include config/config.ahk

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

CapsLock::
{
    WinGetClass("A") ; get active window
    ; Selection := WinGetControls("A")
    HWND := ControlGetFocus("A")
    MsgBox HWND
    ; if (RegExMatch(HWND, "Edit")) {
        Selection := EditGetSelectedText(HWND, "A")
        if (IsLower(Selection)) {
            Selection := StrUpper(Selection)
        } else if (IsUpper(Selection)) {
            Selection := StrTitle(Selection)
        } else {
            Selection := StrLower(Selection)
        }
        EditPaste(Selection, HWND, "A")
    ; }
}