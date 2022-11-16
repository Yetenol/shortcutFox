#Include config/config.ahk
#Include config/trayLayout.ahk
#Include io.ahk

TraySetIcon(DEFAULT_ICON)

class MenuManager {
    static ITEM_TYPES := {    ; all items need an ID and TEXT
        ACTION: 0,    ; Do DELAY interval, RUN file, SEND keystrokes, assumed by default
        GROUP: 1,    ; List of CONTENT seperated by horizontal line, ignores title
        SUBMENU: 2,    ; Expandable submenu with list of CONTENT
        CHOICE: 3,    ; Expandable setting with list of options (CONTENT)
        SWITCH : 4,    ; Toggleable setting, SWITCH sets the default state
    }
    trayMenu := {}
    /**
     * Build the traymenu.
     * @param layout nested object that defined the structure of the traymenu
     */
    __New() {
        A_TrayMenu.ClickCount := 1    ; just require a single click instead of a double click
        this._removeStandard()
        this._parseLayout()
        this._applyDefaultAction()
    }
    clickChoice(choiceId, option, &menu) {
        choiceItem := this._findItem(choiceId)
        writeSetting(choiceId, option)
        this._updateCheckmark(option, &menu)
        if choiceId == "DEFAULT_ACTION" {
            this._applyDefaultAction()
        }
    }
    /**
     * Construct submenu objects to which the entries will be attached.
     * @param layer Layout level whose menu is to be created
     */
    _constructSubmenu(preset := unset) {
        submenu := (IsSet(preset)) ? preset : Menu()
        submenu.content := []
        return submenu
    }
    /**
     * If necessary, dissolve the link in its content.
     * @param item Possible symbolic link
     */
    _pasteSymbolicLinks(&item, &destinationLayer, position) {
        if this._isSymbolicLink(&item) {
            destinationLayer.content[position] := this._getReferencedContent(&item)
        }
    }
    _dissolveSymbolicLinks(&layer) {
        position := 1
        while position <= layer.content.Length {
            item := layer.content[position]
            if this._isSymbolicLink(&item) {
                this._pasteSymbolicLinks(&item, &layer, position)
                position--
            }
            position++
        }
    }
    _inheritIcon(&item := false, &layer := false) {
        if layer.HasOwnProp("icon") {
            icon := layer.icon
            if icon is Object && icon.HasOwnProp("state") {

            } else {
                item.icon := icon
            }
        }
    }
    _referenceChoice(&item, choiceID := false) {
        if choiceID != false {
            item.optionOf := choiceID
        }
    }
    _applyCheckmark(&item, activeOption := false) {
        state := false
        if activeOption != false {
            state := item.id = activeOption
        } else if this._isSwitch(&item) {
            value := readSetting(item.id)
            if value == "NON_PRESENT" {
                state := false
            } else {
                state := value
            }
        } else {
            return
        }

            item.icon := { state: state }
    }
    /**
     * Prepare menu for initialization:
     * - Construct submenu objects to which the entries will be attached.
     * - Replace symbolic links with a copy of their referenced item, submenu or group.
     * @param recursionLayer Definition layer to recursively parse through
     */
    _parseLayout(&layer := unset, menu := unset, requestSeperator := false, choiceID := false, activeOption := false) {
        global TRAY_LAYOUT
        if not IsSet(layer) {
            layer := TRAY_LAYOUT.Clone()
        }
        if not IsSet(menu) {
            menu := this._constructSubmenu(A_TrayMenu)
            this.trayMenu := menu
        }
        this._dissolveSymbolicLinks(&layer)
        for itemDefinition in layer.content {
            item := itemDefinition.Clone()
            this._inheritIcon(&item, &layer)
            this._referenceChoice(&item, choiceID)
            this._applyCheckmark(&item, activeOption)
            switch this._getItemType(item) {
                case MenuManager.ITEM_TYPES.ACTION, MenuManager.ITEM_TYPES.SWITCH:
                    menu.content.Push(item)
                    this._drawItem(&item, &menu, , requestSeperator)
                    requestSeperator := false
                case MenuManager.ITEM_TYPES.GROUP:
                    this._parseLayout(&item, menu, true, choiceID, activeOption)
                case MenuManager.ITEM_TYPES.SUBMENU:
                    submenu := this._constructSubmenu()
                    this._drawItem(&item, &menu, submenu, requestSeperator)
                    requestSeperator := false
                    this._parseLayout(&item, submenu, , choiceID, activeOption)
                case MenuManager.ITEM_TYPES.CHOICE:
                    submenu := this._constructSubmenu()
                    this._drawItem(&item, &menu, submenu, requestSeperator)
                    requestSeperator := false
                    this._parseLayout(&item, submenu, , item.id, readSetting(item.id))
                default:
            }
        }
    }
    _removeStandard() {
        A_TrayMenu.Delete()
    }
    _updateCheckmark(activeId, &menu) {
        for item in menu.content {
            this._applyCheckmark(&item, activeId)
            this._drawIcon(&item, &menu)
        }
    }
    /**
     * Return get type of an item
     * @param item Action, submenu or group to examine
     * @returns ({MenuManager.ITEM_TYPES.} SUBMENU, GROUP or ACTION) or false if invalid
     */
    _getItemType(item) {
        if !this._isValidItem(&item) {
            return false
        }
        if item.HasOwnProp("switch") {
            return MenuManager.ITEM_TYPES.SWITCH
        } else if item.HasOwnProp("content") && item.content is array {
            if item.HasOwnProp("choice") && !item.HasOwnProp("optionOf") {
                return MenuManager.ITEM_TYPES.CHOICE
            } else if this._doesMeetMaxDisplay(&item) {
                return MenuManager.ITEM_TYPES.GROUP
            } else {
                return MenuManager.ITEM_TYPES.SUBMENU
            }
        }
            return MenuManager.ITEM_TYPES.ACTION
    }
    /**
     * Replace the symbolic link with a copy of its referenced item, submenu or group
     * @param linkItem Symbolic link item to replace
     * @param destinationLayer Layer of the symbolic link
     * @param itemPosition Position within the layer
     */
    _getReferencedContent(&linkItem) => this._findItem(linkItem)
    /**
     * Does the element meet its maximum number of children?
     * - if YES: display it as a group seperated by lines
     * - if NO:  display it as a new submenu
     * @param item Submenu or group to examine
     */
    _doesMeetMaxDisplay(&item) {
        if (!item.hasOwnProp("maxDisplay")) {
            return true
        } else if (item.maxDisplay = 0) {
            return false
        } else {
            return item.maxDisplay = -1 || item.content.Length <= item.maxDisplay
        }
    }
    /**
     * Draw the entry into the specified menu.
     * @param item Item to draw
     * @param icon Icon to draw
     * @param menu Menu on which is drawn
     * @param clickhandler Function to run or Submenu to open when clicked
     */
    _drawItem(&item, &menu, clickhandler := unset, requestSeperator := false) {
        if not IsSet(clickhandler) {
            clickhandler := handler
        }
        if requestSeperator {
            this._drawSeperator(&menu)
        }
        menu.add(item.text, clickhandler)
        this._drawIcon(&item, &menu)
    }
    /**
     * Find an item by its id.
     * @param id Target's id
     * @param recursionLayer INTERNAL - Layout level to recursively search through
     */
    _findItem(id, recursively := true, &recursionLayer := unset) {
        global TRAY_LAYOUT
        if (!IsSet(recursionLayer)) {
            recursionLayer := TRAY_LAYOUT    ; recursion starts at the root of the definition
        }
        for item in recursionLayer.content {
            if (this._isValidItem(&item) && item.id = id) {
                return item
            } else if recursively && this._hasChildren(&item) {
                referencedItem := this._findItem(id, recursively, &item)
                if (referencedItem) {
                    return referencedItem
                }
            }
        }
        return false    ; couldn't find item
    }
    /**
     * Draw a seperator line if this has been requested beforehand.
     * @param menu Menu to examine
     */
    _drawSeperator(&menu) {
        menu.add()    ; add a seperator line
    }
    /**
     * Draw the specified icon into a submenu or action
     * @param item Item to draw into
     * @param icon path or [path, index] to apply
     * @param menu traymenu or submenu to which is drawn
     */
    _drawIcon(&item, &menu) {
        if not item.HasOwnProp("icon") {
            return
        }
        icon := item.icon
        if icon is array && icon.Length = 2 {    ; icon contains a path and index
            menu.setIcon(item.text, icon[1], icon[2])
        } else if icon is string {    ; icon only contains a path
            menu.setIcon(item.text, icon)
        } else if icon is object && icon.HasOwnProp("state") {
            menu.SetIcon(item.text, "*")
            if icon.state {
                menu.Check(item.text)
            } else {
                menu.Uncheck(item.text)
            }
        }
    }
    _readDefaultAction() {
        defaultID := readSetting("DEFAULT_ACTION")
        if defaultID ~= "NON_PRESENT|NO_DEFAULT_ACTION" {
            return false
        }
        mainTrayMenu := this.trayMenu
        defaultAction := this._findItem(defaultID, false, &mainTrayMenu)
        if not defaultAction {
            if "yes" = MsgBox("Unkown action:`t" defaultID "`nWhould you like to reset the default action?", "Unkown default action", "YesNo") {
                removeSetting("DEFAULT_ACTION")
            }
            return false
        }
        return defaultAction
    }

    _applyDefaultAction() {
        global DEFAULT_ICON
        action := this._readDefaultAction()
        if not action {
            TraySetIcon(DEFAULT_ICON)
            A_TrayMenu.Default := ""
            return
        }
        icon := action.icon
        if icon is array {    ; icon contains a path and index
            TraySetIcon(icon[1], icon[2])
        } else if icon is string {    ; icon only contains a path
            TraySetIcon(icon)
        }
            A_TrayMenu.Default := action.text
    }
    _isSwitch(&item) => item.HasOwnProp("switch")
    /**
     * Is the item a symbolic link to another submenu or group?
     * @param item Action, submenu, group or symbolic link to examine
     */
    _isSymbolicLink(&item) => item is string
    /**
     * Does the item fullfill the minimum specifications for a menu entry?
     * @param item Action, submenu, group or symbolic link to examine
     */
    _isValidItem(&item) => item is object && item.hasOwnProp("id")
    /**
     * Does the element contain children, which is true for submenus and groups?
     * @param item Action, submenu, group or symbolic link to examine
     */
    _hasChildren(&item) => this._isValidItem(&item) && item.hasOwnProp("content")
}
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
    if action.hasOwnProp("send") {
        Send action.send
    }
    if action.hasOwnProp("run") {
        file := NormalizePath(action.run)
        Run file, A_WorkingDir
    }
    if action.HasOwnProp("switch") {
        menu.ToggleCheck(itemName)
        toggleSetting(action.id)
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