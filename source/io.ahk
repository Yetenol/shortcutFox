CONFIG_PATH := A_AppData "\Window Tools"
if not FileExist(CONFIG_PATH) {
    FileCreateDir, % CONFIG_PATH
}

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