
; ==================== Window Lists: ====================
; Is the active window a browser?
IsBrowserActive() {
    return WinActive("ahk_exe firefox.exe") || WinActive("ahk_exe msedge.exe") || WinActive("ahk_exe chrome.exe")
}

; Is active window a media player?
IsMediaPlayerActive() {
    return (WinActive("Netflix ahk_class ApplicationFrameWindow") ;  Netflix
        || WinActive("Amazon Prime Video for Windows ahk_class ApplicationFrameWindow")) ; PrimeVideo
}

; Is active window a OS core app or a protected backgroup app?
isCoreApp() {
    if (windowExe = ahk_exe "Explorer.EXE" && windowClass = "Shell_TrayWnd") ; Taskbar
        || (windowExe = ahk_exe "Explorer.EXE" && windowClass = "WorkerW") ; Desktop
        || (windowExe = ahk_exe "Explorer.EXE" && windowClass = "Progman") ; Desktop
        || (windowExe = "ApplicationFrameHost.exe" && windowClass = "ApplicationFrameWindow") ; Windows Store Apps
        || (windowExe = "Rainmeter.exe" && windowClass = "RainmeterMeterWindow")  ; Rainmeter widget
    {
        return true
    } 
    else 
    { ; Valid window found
        return false
    }
}