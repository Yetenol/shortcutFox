#Include config\config.ahk

createSettingsFile()
createStartMenuShortcut()

/** Create a settings file in the appdata user folder
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

/** Add shortcut to this application to the start menu.
 * Then you can search and launch the app through Windows Start.
 */
createStartMenuShortcut() {
    global START_MENU_FILE
    if not FileExist(START_MENU_FILE) {
        FileCreateShortcut(A_ScriptFullPath, START_MENU_FILE)
    }
}