; returns false if file doesn't exist
getTrayDefault() {
    path := getConfigPath() "\trayDefault.txt"
    if FileExist(path) {
        FileRead, content, % path
        return content
    } else {
        return false
    }
}

setTrayDefault(actionLabel) {
    path := getConfigPath() "\trayDefault.txt"
    FileDelete, % path
    FileAppend, % actionLabel, % path
}

getConfigPath() {
    EnvGet, AppDataPath, % "AppData"
    return AppDataPath "\Window Tools"
}