CONFIG_FILE := A_AppData "\shortcutFox\settings.ini"
CONFIG_SECTION := "Settings"

if not FileExist(CONFIG_FILE) {
    Run "powershell.exe -Command New-Item -Path " CONFIG_FILE " -Force"
}

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
    global CONFIG_FILE, CONFIG_SECTION
    IniWrite(value, CONFIG_FILE, CONFIG_SECTION, id)
}

removeSetting(id) {
    global CONFIG_FILE, CONFIG_SECTION
    if hasSetting(id) {
        IniDelete(CONFIG_FILE, CONFIG_SECTION, id)
    }
}