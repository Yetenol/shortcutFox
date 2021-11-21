; is the config available?
hasTrayDefault() {
    path := getConfigPath() "\trayDefault.txt"
    return FileExist(path)
}

; read trayDefault config
; returns false if config isn't available
loadTrayDefault() {
    path := getConfigPath() "\trayDefault.txt"
    if FileExist(path) {
        FileRead, content, % path
        return content
    } else {
        return false
    }
}

saveTrayDefault(actionLabel) {
    path := getConfigPath() "\trayDefault.txt"
    FileDelete, % path
    FileAppend, % actionLabel, % path
}

getConfigPath() {
    EnvGet, AppDataPath, % "AppData"
    return AppDataPath "\Window Tools"
}