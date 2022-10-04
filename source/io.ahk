startupShortcut := A_AppData "\Microsoft\Windows\Start Menu\Programs\Startup\shortcutFox.lnk"

CONFIG_FILE := A_AppData "\shortcutFox\settings.ini"
CONFIG_SECTION := "Settings"
; if (!DirExist(CONFIG_FILE)) {
; DirCreate CONFIG_FILE
; }


; is the config available?
hasSetting(id) {
    global CONFIG_FILE
    value := IniRead(CONFIG_FILE, CONFIG_SECTION, id, "NON_PRESENT")
    return value != "NON_PRESENT"
}

; read trayDefault config
; returns false if config isn't available
readSetting(id) {
    value := IniRead(CONFIG_FILE, CONFIG_SECTION, id, "NON_PRESENT")
    if (value ~= "1|yes|true|and|on") {
        return true
    } else if (value ~= "0|no|false|off") {
        return false
    } else {
        return value
    }
}

writeSetting(id, value) {
    IniWrite(value, CONFIG_FILE, CONFIG_SECTION, id)
}

toggleSetting(id) {
    writeSetting(id, !readSetting(id))
}