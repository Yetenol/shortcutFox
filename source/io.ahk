CONFIG_FOLDER := A_AppData "\shortcutFox"
CONFIG_FILE := CONFIG_FOLDER "\settings.ini"
CONFIG_SECTION := "Settings"
START_MENU_FILE := A_Programs "\shortcutFox.lnk"

createConfigFile()
createStartMenuShortcut()


/** Create a settings file in the appdata user folder
 */
createConfigFile() {
    if not DirExist(CONFIG_FOLDER) {
        DirCreate(CONFIG_FOLDER)
    }
    if not FileExist(CONFIG_FILE) {
        FileAppend "", CONFIG_FILE
    }
}

/** Add shortcut to this application to the start menu.
 * Then you can search and launch the app through Windows Start.
 */
createStartMenuShortcut() {
    if not FileExist(START_MENU_FILE) {
        FileCreateShortcut(A_ScriptFullPath, START_MENU_FILE)
    }
}

/** Has the given settings id been set?
 * @param id identifies which setting to check. Id is a name in constant case.
 * @returns {bool} true if set, false if unset
 */
hasSetting(id) {
    global CONFIG_FILE
    value := IniRead(CONFIG_FILE, CONFIG_SECTION, id, "NON_PRESENT")
    return value != "NON_PRESENT"
}

/** Load a specific setting from the settings file
 * @param id (in constant case) names the setting to be read.
 * @returns {text} value of the setting
 */
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

/** Write a specific setting to the settings file
 * @param id (in constant case) names the setting to be set.
 * @param value to set the setting to
 */
writeSetting(id, value) {
    global CONFIG_FILE, CONFIG_SECTION
    IniWrite(value, CONFIG_FILE, CONFIG_SECTION, id)
}

/** Unset a specific setting in the settings file 
 * @param id (in constant case) names the setting to be removed.
 */
removeSetting(id) {
    global CONFIG_FILE, CONFIG_SECTION
    if hasSetting(id) {
        IniDelete(CONFIG_FILE, CONFIG_SECTION, id)
    }
}