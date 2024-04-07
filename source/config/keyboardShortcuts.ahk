#Include config.ahk

SetNumLockState True
SetCapsLockState "AlwaysOff"
DetectHiddenWindows True
SetTimer apply_reddit_wallpaper, 1000*60*60


apply_reddit_wallpaper()
{
    if readSetting("APPLY_REDDIT_WALLPAPER") {
        Run "Powershell -ExecutionPolicy Bypass -File .\scripts\applyRedditWallpaper.ps1", A_WorkingDir, "Hide"
    }
}

is_Keeweb_installed() {
    global KEEWEB_PATH
    return FileExist(KEEWEB_PATH) != false
}

Focus_Keeweb_once_it_exists() {
    WinWait("ahk_exe KeeWeb.exe", , 2)
    If WinExist("ahk_exe KeeWeb.exe") {
        WinActivate
    }
}

Launch_KeeWeb_in_the_background() {
    global KEEWEB_PATH
    window_to_reactivate := WinGetTitle("A")
    Run KEEWEB_PATH
    WinWaitNotActive(window_to_reactivate, , 2)
    WinActivate(window_to_reactivate)
}

/** Open the PowerToys Run quick launcher instead of the Windows start menu.
 * To implement this, intercept when only the Windows key is pressed and released.
 * Keyboard shortcuts such as Win+R are passed through to the system to maintain normal functionality.
 */
ih := InputHook("L1")
#HotIf readSetting("HOTKEY_WINKEY_STARTS_POWERTOYS_RUN")
LWin::
{
    ih.Start()
    ErrorLevel := ih.Wait()
    if (ErrorLevel = "Stopped") ; If catching was interrupted
    {
        Send "!{Space}" ; Set this to your powertoys run shortcut
    } else {
        Send "#" ih.Input ; Sends winkey + caught key
    }
}
#HotIf readSetting("HOTKEY_WINKEY_STARTS_POWERTOYS_RUN")
~LWin Up::
{
    ih.Stop()
}


/** Switch between word capitalizations in editor programs. 
* To do this, send the key combination that is set 
* in the respective plugin of the program.
*/
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

/** Open KeeWeb. 
 * If it is not running yet, start it. Otherwise, bring it to the foreground.
 */
#HotIf readSetting("HOTKEY_LAUNCH_KEEWEB") and is_Keeweb_installed()
#+V::
{
    global KEEWEB_PATH
    DetectHiddenWindows False
    If WinExist("ahk_exe KeeWeb.exe") {
        WinActivate
    } else {
        Run KEEWEB_PATH
        Focus_Keeweb_once_it_exists()
    }
    DetectHiddenWindows True
}

/** Start and pop up KeeWeb when a login form is to be filled in the browser.
 * This script runs only when KeeWeb is not running. Therefore it intercepts 
 * the keyboard shortcut in the browser so that it does not throw a connection error. 
 * KeeWeb is started, the focus is set back to the browser and the keyboard shortcut 
 * to fill in the form is sent again, which pops up KeeWeb in fill in mode.
 */
#HotIf (WinActive("ahk_exe msedge.exe") and !WinExist("ahk_exe KeeWeb.exe"))
and readSetting("HOTKEY_PASTE_KEEWEB") and is_Keeweb_installed()
^+v::
{
    Launch_KeeWeb_in_the_background()
    Sleep 500
    SendEvent "^+v"
    Focus_Keeweb_once_it_exists()
}

/** Pops up KeeWeb when a login form is to be filled in the browser.
 * This script runs only when KeeWeb is running. The key combination in 
 * the browser is not intercepted, so KeeWeb is requested to fill in. 
 * This script ensures that the app also pops up, which is otherwise unreliable.
 */
#HotIf (WinActive("ahk_exe msedge.exe") and WinExist("ahk_exe KeeWeb.exe"))
and readSetting("HOTKEY_PASTE_KEEWEB") and is_Keeweb_installed()
~^+v::
{
    DetectHiddenWindows False
    WinWait("ahk_exe KeeWeb.exe", , 2)
    If WinExist("ahk_exe KeeWeb.exe") {
        WinActivate
    }
    DetectHiddenWindows True
}

/** Insert the current date formatted as ISO 8601 (YYYY-MM-DD).
 */
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

