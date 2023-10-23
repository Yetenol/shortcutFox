/** Has the given settings id been set?
 * @param id identifies which setting to check. Id is a name in constant case.
 * @returns {bool} true if set, false if unset
 */
hasSetting(id) {
    global SETTINGS_FILE
    value := IniRead(SETTINGS_FILE, SETTINGS_SECTION, id, "NON_PRESENT")
    return value != "NON_PRESENT"
}

/** Load a specific setting from the settings file
 * @param id (in constant case) names the setting to be read.
 * @returns {text} value of the setting
 */
readSetting(id) {
    value := IniRead(SETTINGS_FILE, SETTINGS_SECTION, id, "NON_PRESENT")
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
    global SETTINGS_FILE, SETTINGS_SECTION
    IniWrite(value, SETTINGS_FILE, SETTINGS_SECTION, id)
}

/** Unset a specific setting in the settings file 
 * @param id (in constant case) names the setting to be removed.
 */
removeSetting(id) {
    global SETTINGS_FILE, SETTINGS_SECTION
    if hasSetting(id) {
        IniDelete(SETTINGS_FILE, SETTINGS_SECTION, id)
    }
}