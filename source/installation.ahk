#Include config\config.ahk

createSettingsFile()
createStartMenuShortcut()

/** Creates settings file to remember checkboxes statuses. 
 * Add a folder and an INI file for settings to the current user's app data.
 */
createSettingsFile() {
    global SETTINGS_FOLDER, SETTINGS_FILE
    if not DirExist(SETTINGS_FOLDER) {
        DirCreate(SETTINGS_FOLDER)
    }
    if not FileExist(SETTINGS_FILE) {
        FileAppend "", SETTINGS_FILE
    }
}


/** Add this application to Windows start menu, to be able to launch it through Windows Start.
 * Creates a shortcut to this executable in the programs common user folder
*/
createStartMenuShortcut() {
    global START_MENU_FILE
    if A_IsCompiled and (not FileExist(START_MENU_FILE)) {
        FileCreateShortcut(A_ScriptFullPath, START_MENU_FILE)
    }
}