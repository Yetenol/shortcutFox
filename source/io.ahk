readSetting(id) {

}

startupShortcut := A_AppData "\Microsoft\Windows\Start Menu\Programs\Startup\shortcutFox.lnk"

CONFIG_PATH := A_AppData "\shortcutFox"
if not FileExist(CONFIG_PATH) {
    FileCreateDir, CONFIG_PATH
}


; is the config available?
hasSetting(id) {
    global CONFIG_PATH
    path := CONFIG_PATH "\" id ".ini"
    return FileExist(path)
}

; read trayDefault config
; returns false if config isn't available
readSetting(id) {
    path := _getSettingPath(id)
    if (FileExist(path)) {
        return FileRead(path)
    } else {
        return false
    }
}

writeSetting(id) {
    path := _getSettingPath(id)
    FileDelete path
    FileAppend id, path
}

_getSettingPath(id) {
    global CONFIG_PATH
    return CONFIG_PATH "\" id ".ini"
}