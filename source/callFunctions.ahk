; internal functions available via the call: configuration

call(functionId, id) {
    switch functionId, false {
        case "closeApp()":
            closeApp()    
        case "toggleSuspend()":
            toggleSuspend(id)    
        case "toggleRunAtStartup()":
            toggleRunAtStartup(id)
        case "applyDefaultAction()":
            tray.applyDefaultAction()
        default:
            throw ValueError("Cannot call an unknown function id.", "call", functionId)
    }
}

; Terminate shortcutFox
closeApp() {
    ExitApp 0
}

; Disable or enable all the selected hotkeys
toggleSuspend(id) {
    Suspend
}

toggleRunAtStartup(id) {
    global STARTUP_SHORTCUT
    if FileExist(STARTUP_SHORTCUT) {
        FileDelete(STARTUP_SHORTCUT)
    }
    if false = readSetting(id) {
        return
    }
    if not confirmLinkUncompiled() {
        return
    }
    FileCreateShortcut(A_ScriptFullPath, STARTUP_SHORTCUT, , , "shortcutFox")
}

confirmLinkUncompiled() {
    if (A_IsCompiled) {
        return true
    }
    prompt := (
        "shortcutFox isn't compiled into an executable.`n"
        "Are you sure you want to run the following file on startup?`n"
        A_ScriptFullPath
    )
    return "Yes" = MsgBox(prompt, "Not compiled", "YesNo")
}