#Include config\config.ahk

createConfigFile()
createStartMenuShortcut()

/** Create a settings file in the appdata user folder
 */
createConfigFile() {
    global CONFIG_FOLDER, CONFIG_FILE
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
    global START_MENU_FILE
    if not FileExist(START_MENU_FILE) {
        FileCreateShortcut(A_ScriptFullPath, START_MENU_FILE)
    }
}