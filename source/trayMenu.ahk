#Include config/config.ahk
#Include config/trayShortcuts.ahk
#Include io.ahk
#Include callFunctions.ahk

TraySetIcon(DEFAULT_ICON)


/**
 * Display debugging information about the clicked entry.
 * @param itemName Entry's text
 * @param itemPosition Entry's position within its submenu
 * @param menu Entry's submenu or traymenu
 */
handler(itemName, itemPosition, menu) {
    action := findAction(&menu, itemName)
    if action = false {
        throw TargetError("Cannot find clicked item")
    }
    if action.HasOwnProp("optionOf") {
        tray.clickChoice(action.optionOf, action.id, &menu)
        return
    }

    if action.HasOwnProp("delay") {
        Sleep action.delay
    }
    if action.HasOwnProp("send") {
        Send action.send
    }
    if action.HasOwnProp("run") {
        file := NormalizePath(action.run)
        SplitPath file, , , &extension
        if (extension = "ps1") {
            Run "Powershell -ExecutionPolicy Bypass -File " file, A_WorkingDir
        }
        Run file, A_WorkingDir
    }
    if action.HasOwnProp("switch") {
        tray.clickSwitch(&action, &menu)
    }
    if action.HasOwnProp("call") {
        call(action.call, action.id)
    }
}
/**
 * Find the corresponding action for the clicked item
 * @param menu Menu where the click took place
 * @param text Name of the clicked item
 */
findAction(&menu, text) {
    for item in menu.content {
        if item.text == text {
            return item
        }
    }
    return false    ; couldn't find item
}

NormalizePath(path) {
    cc := DllCall("GetFullPathName", "str", path, "uint", 0, "ptr", 0, "ptr", 0, "uint")
    buf := Buffer(cc * 2)
    DllCall("GetFullPathName", "str", path, "uint", cc, "ptr", buf, "ptr", 0)
    return StrGet(buf)
}