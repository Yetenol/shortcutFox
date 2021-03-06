CONFIG_PATH := A_AppData "\shortcutFox"
if not FileExist(CONFIG_PATH) {
    FileCreateDir, % CONFIG_PATH
}

startupShortcut := A_AppData "\Microsoft\Windows\Start Menu\Programs\Startup\shortcutFox.lnk"

; is the config available?
hasTrayDefault() {
    global CONFIG_PATH
    path := CONFIG_PATH "\trayDefault.txt"
    return FileExist(path)
}

; read trayDefault config
; returns false if config isn't available
loadTrayDefault() {
    global CONFIG_PATH
    path := CONFIG_PATH "\trayDefault.txt"
    if FileExist(path) {
        FileRead, content, % path
        return content
    } else {
        return false
    }
}

saveTrayDefault(actionLabel) {
    global CONFIG_PATH
    path := CONFIG_PATH "\trayDefault.txt"
    FileDelete, % path
    FileAppend, % actionLabel, % path
}

getRunAtStartup() {
    global startupShortcut
    return FileExist(startupShortcut)
}

toggleRunAtStartup() {
    global startupShortcut
    if (getRunAtStartup()) {
        FileDelete, % startupShortcut
    } else {
        FileCreateShortcut, % A_ScriptFullPath, % startupShortcut
    }
}

