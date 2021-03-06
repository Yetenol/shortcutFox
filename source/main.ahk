#SingleInstance, force ; Override existing instance when lauched again
#Include, <utilities>
#Include, closeWindow.ahk
#Include, io.ahk
#Include, trayMenu.ahk
#Include, windowCategories.ahk
SetWorkingDir, % A_ScriptDir ; Ensures a consistent working directory (script folder)


; ========================= Setup Keyboard Modifications =========================
SetNumLockState, AlwaysOn ; Always use digits on NumPad
return
; ========================= End of Setup =========================

; ==================== Windows Media API ====================
; Enables remote media control for media apps like Netflix and PrimeVideo

; Play/Pause media (Netflix, PrimeVideo)
Media_Play_Pause::
    media_is_winding := false ; stop media winding
    if (IsMediaPlayerActive())
    {
        Send, {Space}
    }
return

#MaxThreadsPerHotkey 2; allow 2 threads so that these hotkeys can "turn themselves off"
; Fast Forwards media until key pressed again or paused (Netflix, PrimeVideo)
Media_Next::
    MediaWind("fast_forward")
return

; Rewind media until key pressed again or paused (Netflix, PrimeVideo)
Media_Prev::
    MediaWind("rewind")
return
#MaxThreadsPerHotkey 1 ; default

MediaWind(direction) 
{
    global media_is_winding
    if (IsMediaPlayerActive()) 
    {
        media_is_winding := !media_is_winding ; start/stop winding (stop kills over thread)
        while (media_is_winding && IsMediaPlayerActive())
        {
            Send, % (direction="fast_forward") ? "{Right}" : "{Left}" ; forward media / rewind media
            Sleep, % WinActive("Netflix") ? WinActive("Amazon Prime Video for Windows") ? 1500 : 1000 : 1000
        }
    }
    return
}




; ==================== Touchpad gestures ====================
; ===== Close gesture =====
^Pause:: ; Close all windows of that process    (Ctrl + Three finger down)
+Pause:: ; Close window                        (Shift + Three finger down)
Pause:: ; Close tab if existing otherwise close window (Three finger down)    
    if GetKeyState("Ctrl", "P") ; Is Ctrl pressed?
        && !isCoreApp()
    { ; Close active window group
        closeWindowGroup()
    }
    else if !GetKeyState("Ctrl", "P") ; Nether Ctrl
        && !GetKeyState("Shift", "P") ; nor Shift is pressed?
    { ; Close tab (if one exist), otherwise close window
        switch isTabActive()
        {
        Case true:
            Send, ^w ; Close tab
        Case false:
            Send, !{F4} ; Close window
        default: ; cannot detect correctly => require Shift or Ctrl to close
        }
    }
    else
    { ; No key is pressed or pretected core app
        Send, !{F4} ; Close window
    }
return

; ===== Open gesture =====
+CtrlBreak::
CtrlBreak:: ; Open new tab / Open action center (Three finger tap)
    if (WinActive("ahk_exe bMC.exe"))
    { ; Baramundi Managment Center
        ; Open the Environment tab?
        image := getFile("BMC environment tab.png", [".", "resources"])
        if (!clickImageInWindow("ahk_exe bMC.exe", image))
        { ; Cannot find image!
            toastError("Cannot find Environment tab")
        }
    }
    else if IsBrowserActive() 
    { ; Browser(like) window is active
        Send, ^t ; Open new tab
    }
    else if WinActive("ahk_exe WindowsTerminal.exe")
    {
        Send, ^+t ; Open new tab
    }
    else if WinActive("ahk_exe code.exe")
    {
        Send, ^n ; New file
    }
    else
    {
        if GetKeyState("Shift", "P")
        {
            Send, #a ; Open quick settings
        }
        else
        {
            Send, #n ; Open action center
        }
    }
return



; ==================== Window shortcuts ====================
; Toogle active window always on top (Win + Ctrl + T)
#^t::
    if (wasAlwaysOnTop := isAlwaysOnTop("A")) {
        clearOutline()
    } else {
        outlineWindow()
    }

    Winset, Alwaysontop, Toggle, A

    isAlwaysOnTop := isAlwaysOnTop("A")
    toggledSuccessfully := (isAlwaysOnTop != wasAlwaysOnTop)
    if (toggledSuccessfully) {
        if (isAlwaysOnTop) {
            SoundPlay, % A_WinDir "\Media\Speech On.wav"
        } else {
            SoundPlay, % A_WinDir "\Media\Speech Sleep.wav"
        }
    } else {
        clearOutline()
    }
return

; Restart StartMenu process (Win + F5)
#F5::
    Run, powershell -Command "Stop-Process -ProcessName StartMenuExperienceHost"
    Sleep, 1000
    Send, {LWin}
return

; Restart Explorer process (Win + Shift + F5)
#+F5::
    Run, powershell -Command "Stop-Process -ProcessName Explorer"
    Sleep, 2000
    Send, {LWin}
return


; Open KeeWeb (Win + Shift + V)
#+V::
    if (FileExist("C:\Program Files\KeeWeb\KeeWeb.exe")) {
        if (WinExist("ahk_exe KeeWeb.exe")) {
            WinActivate, % "ahk_exe KeeWeb.exe"
        } else {
            Run, % "C:\Program Files\KeeWeb\KeeWeb.exe"
        }
    }
return



; ==================== Transparency shortcuts ====================

; Make active window transparent
; - Uses external program nircmd in path location

; Clear active window's transparency (Win + Numpad0)
#Numpad0::
    Run, nircmd win trans foreground 255
return
; Set active window's transparency to 90% (Win + Numpad1)
#Numpad1::
    Run, nircmd win trans foreground 227
return
; Set active window's transparency to 78% (Win + Numpad2)
#Numpad2::
    Run, nircmd win trans foreground 198
return
; Set active window's transparency to 67% (Win + Numpad3)
#Numpad3::
    Run, nircmd win trans foreground 170
return
; Set active window's transparency to 56% (Win + Numpad4)
#Numpad4::
    Run, nircmd win trans foreground 142
return
; Set active window's transparency to 44% (Win + Numpad5)
#Numpad5::
    Run, nircmd win trans foreground 113
return
; Set active window's transparency to 33% (Win + Numpad6)
#Numpad6::
    Run, nircmd win trans foreground 85
return
; Set active window's transparency to 22% (Win + Numpad7)
#Numpad7::
    Run, nircmd win trans foreground 57
return
; Set active window's transparency to 11% (Win + Numpad8)
#Numpad8::
    Run, nircmd win trans foreground 28
return
; Make active window's transparency invisible (Win + Numpad9)
#Numpad9::
    Run, nircmd win trans foreground 0
return

; Send PAUSE
SendPause:
    toastInfo("Send PAUSE", "Sending PAUSE in 2s",, false)
    Sleep, 2000
    Send, % "{Pause}"
return

; Send CTRL + PAUSE
SendCtrlBreak:
    toastInfo("Send PAUSE", "Sending CTRL + PAUSE in 2s",, false)
    Sleep, 2000
    Send, % "{CtrlBreak}"
return


outlineWindow() {
    OUTLINE_THICKNESS = 4 ; frame line thickness

	Gui, +Lastfound +AlwaysOnTop +Toolwindow
	Gui, Color, % readAccentColor()
	Gui, -Caption

    ; get parameters
	WinGetPos, x, y, width, height, A
    thickness := 2*OUTLINE_THICKNESS

    ; correct window position
    x := x + 8 - thickness/2 ; left to right
    y := y + 1 - thickness/2 ; top to bottom
    width := width - 16 + thickness
    height := height - 9 + thickness
    
    ; define outer frame points
    outerTopLeft     :=  "0-0"
    outerTopRight    := width "-0"
    outerBottomLeft  :=  "0-" height
    outerBottomRight := width "-" height
    
    ; define inner frame points
    innerTopLeft     := thickness "-" thickness
    innerTopRight    := (width - thickness) "-" thickness
    innerBottomLeft  := thickness "-" (height - thickness)
    innerBottomRight := (width - thickness) "-" (height - thickness)
	
    ; draw frame
    framePointsOutside := outerTopLeft " " outerTopRight " " outerBottomRight " " outerBottomLeft " " outerTopLeft
    framePointsInside := innerTopLeft " " innerTopRight " " innerBottomRight " " innerBottomLeft " " innerTopLeft
    frame := framePointsOutside " " framePointsInside
    WinSet, Region, % frame
	Gui, Show, % "w" width " h" height " x" x " y" y " NoActivate", % "AlwaysOnTop Outline"
}

clearOutline() {
    Gui, Destroy
}

readAccentColor() {
    RegRead, accentRgb, HKCU\SOFTWARE\Microsoft\Windows\DWM, ColorizationColor
    VarSetCapacity(accentHex, 17 << !!A_IsUnicode, 0)
    DllCall("Shlwapi.dll\wnsprintf", "Str", accentHex, "Int", 17, "Str", "%016I64X", "UInt64", accentRgb, "Int")
    return SubStr(accentHex, StrLen(accentHex) - 6 + 1)
}

isAlwaysOnTop(window) {
    WinGet, ExStyle, ExStyle, % window
    return (ExStyle & 0x8)
}