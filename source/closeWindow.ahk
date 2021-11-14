; Close tab (if it exist), otherwise close window
; Does the active window have tabs that can be close with `Ctrl + W`?
isTabActive() {
    if IsBrowserActive() ; A browser is active
        || WinActive("ahk_exe code.exe") ; Visual Studio Code
    { 
        return true ; Tab detected
    } 
    else if WinActive("ahk_exe AcroRd32.exe") ; Adobe Acrobat Reader DC is active
        && !WinActive("Adobe Acrobat Reader DC (32-bit)") ; No file is open
    { 
        SetTitleMatchMode, 3 ; Window Title must be exactly matched
        if (!WinActive("Adobe Acrobat Reader DC (32-bit)"))
        { ; Adobe Reader has no tab open
            return true ; Tab detected
        }
    }
    else if (WinActive("ahk_exe bMC.exe")) ; Baramundi Managment Center
    { 
        ; Is the active tab a client?
        image := getFile("BMC Active client.png", [".", "resources"])
        if (locateImageInWindow("ahk_exe bMC.exe", image))
        { ; Found image! => Active tab is a client
            return true ; Tab detected
        }
        else
        { ; Cannot find image! => No client is active
            ; Is there an inactive client open?
            image := getFile("BMC Inactive client.png", [".", "resources"])
            if (clickImageInWindow("ahk_exe bMC.exe", image))
            { ; Found image! => Switched to inactive client
                return true ; Tab detected
            }
            else
            { ; Cannot find image! => No clients are open
                ; Protected tab shoundn't be closed
                image := getFile("BMC Expand client.png", [".", "resources"])
                if (clickImageInWindow("ahk_exe bMC.exe", image))
                { ; Found image! => At least one client open
                    return "noTarget" ; cannot detect correctly => require Shift or Ctrl to close
                }
                else
                { ; Cannot find image! => No client open
                    return "noTarget" ; cannot detect correctly => require Shift or Ctrl to close
                    toastQuestion("No more clients found!", "Do you want to exit?", 3, false, 0x4)
                    IfMsgBox, Yes
                    {
                        return false ; No tab detected
                    }
                }
            }
        }
    }
    else if (WinActive("ahk_exe gitkraken.exe")) ; GitKraken is active but no tab is open
    { 
        image := getFile("GitKraken single empty tab.png", [".", "resources"])
        if (!locateImageInWindow("ahk_exe gitkraken.exe", image))
        { ; Cannot find image! => At least one tab open
            return true ; Tab detected
        }
    }
    else {
        return false ; No tab detected
    }
}

; Close all windows of that process
closeWindowGroup() {
    ; Retrive information about active window group
    WinGet, windowExe, ProcessName, % "A"
    WinGetClass, windowClass, % "A"

    ; Get all candidates for windows of the same window group
    GroupAdd, activeGroup, % "ahk_exe " windowExe " ahk_class " windowClass
    WinGet, windowList, List, % "ahk_group activeGroup"

    ; Double check all candidates
    loop, % windowList
    {
        ; Only close candidates of same ProcessName and WindowClass
        WinClose, % "ahk_id " windowList%A_Index% " ahk_exe " windowExe " ahk_class " windowClass
    }
}