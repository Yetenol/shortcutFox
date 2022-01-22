#Include TRAYMENU_LAYOUT.ahk
#Include core.ahk

class MenuManager {
    _LAYOUT := false	; imported definition of the layout
    _traymenu := A_trayMenu

    static TYPES := {	; Enumeration for all types of items
        ACTION: 0,
        /*  - used as DEFAULT
        - type can be omitted
         */
        GROUP: 1,
        /*  - child items listed above each other
        - displays a line before and after the group
        - doesn't show title
         */
        SUBMENU: 2,
        /*  - display title as single item
        - hovering over it expands a new menu with child item
         */
    }

    /** Constructor
     */
    __New(&layout) {
        this._LAYOUT := layout
        this._parseLayout(&layout)
        this.update()
    }

    /** Rerender the entire traymenu.
     */
    update() {
        this.clear()
        this._attachItem()
    }

    clear(recursionLayer := unset) {
        if (!isSet(recursionLayer)) {
            recursionLayer := this._LAYOUT	; start recursion at top level of layout definition
        }
        recursionLayer.menu.delete()
        recursionLayer.menu.isEmpty := true

        for item in recursionLayer.content {
            if (this._isSubmenuOrGroup(&item)) {
                this.clear(item)
            }
        }
    }

    /** Print the current traymenu layout into a file
     * @param {string} [filename=traymenu.txt] - file to override
     * recursion internal:
     * @param {Object[]} [recursionLayer=_LAYOUT] - array of items to recursively iterate through
     * @param {int} [layerIndex=0] - position within the current recursionLayer
     * @param {int} [first=false] - is it the first item of the current recursionLayer?
     * @param {int} [last=false] - is it the last item of the current recursionLayer?
     */
    logAll(filename := "traymenu.txt", recursionLayer := unset, layerIndex := 0, first := false, last := false) {
        if (!isSet(recursionLayer)) {
            recursionLayer := this._LAYOUT	; start recursion at top level of layout definition
            if (fileExist(filename)) {
                fileDelete(filename)
            }
        }

        indent := ""
        loop layerIndex {
            indent := indent " "
        }

        if (first && last) {
            draw := "└"
        } else if (first) {
            draw := "├"
        } else if (last) {
            draw := "└"
        } else {
            draw := "├"
        }

        line := indent draw " " recursionLayer.id "`n"

        fileAppend(line, filename, "UTF-8")

        if (recursionLayer.hasOwnProp("content")) {
            max := recursionLayer.content.Length
            for i, item in recursionLayer.content {
                first := (i = 1)
                last := (i = max)
                this.logAll(filename, item, layerIndex + 1, first, last)
            }
        }
    }

    _parseLayout(&recursionLayer) {
        logIfDebug("parseLayout", "layer:`t" recursionLayer.id, "content:`t" recursionLayer.content.Length)
        this._constructSubmenu(&recursionLayer)
        for position, item in recursionLayer.content {
            this._dissolveSymbolicLinks(&item, &recursionLayer, position)
            if (this._isSubmenuOrGroup(item)) {
                this._parseLayout(&item)
            }
        }
    }

    _constructSubmenu(&recursionLayer) {
        recursionLayer.menu := (recursionLayer.id = "TRAYMENU") ? this._traymenu : Menu()
        recursionLayer.menu.name := recursionLayer.id
    }

    _dissolveSymbolicLinks(&item, &destinationLayer, position) {
        if (this._isSymbolicLink(item)) {
            this._pasteReferencedContent(&item, &destinationLayer, position)
        }
    }

    _isSymbolicLink(item) => item is string

    _isValidItem(item) => (item is object) && item.hasOwnProp("id")

    _isSubmenuOrGroup(item) => this._isValidItem(item) && item.hasOwnProp("content")

    _pasteReferencedContent(&item, &destinationLayer, itemPosition) {
        destinationLayer.content[itemPosition] := this._findItem(item)
    }

    _getItemType(item) {
        if (this._isSubmenuOrGroup(item)) {
            if (this._doesMeetMaxDisplay(&item)) {
                return MenuManager.TYPES.GROUP
            } else {
                return MenuManager.TYPES.SUBMENU
            }
        } else if (this._isValidItem(item)) {
            return MenuManager.TYPES.ACTION
        } else {
            return false
        }
    }

    _doesMeetMaxDisplay(&item) {
        if (!item.hasOwnProp("maxDisplay")) {
            return true
        } else if (item.maxDisplay = 0) {
            return false
        } else {
            return item.maxDisplay = -1 || item.content.Length <= item.maxDisplay
        }
    }

    _attachItem(&item := unset, &recursionMenu := unset, &inheritIcon := false) {
        if (!isSet(item)) {	; recursion starts at the root of the definition
            item := this._LAYOUT
        }
        if (!isSet(recursionMenu)) {	; recursion starts at the root of the definition
            recursionMenu := this._traymenu
        }

        if (!inheritIcon && item.hasOwnProp("icon")) {
            icon := item.icon
        } else {
            icon := inheritIcon
        }

        ; MsgBox("attachItem`nitem:`t" item.id "`nmenu:`t" menu.name)

        switch this._getItemType(item)
        {
            case MenuManager.TYPES.GROUP:
                recursionMenu.requestSeperator := true	; remember to add a seperator line before the next item on this submenu level
                this._attachChildren(&item, &icon, &recursionMenu)
                recursionMenu.requestSeperator := true	; remember to add a seperator line before the next item on this submenu level

            case MenuManager.TYPES.SUBMENU:
                this._attachChildren(&item, &icon, )
                this._drawItem(&item, &icon, &recursionMenu, )

            case MenuManager.TYPES.ACTION:
                this._drawItem(&item, &icon, &recursionMenu, handler)
        }
    }

    _attachChildren(&item, &inheritIcon, &destinationMenu := unset) {
        if (!isSet(destinationMenu)) {
            destinationMenu := item.menu
        }

        if (this._isSubmenuOrGroup(item)) {
            for child in item.content {
                this._attachItem(&child, &destinationMenu, &inheritIcon)
            }
        }
    }

    _drawItem(&item, &icon, &menu := unset, clickhandler := unset) {
        if (!isSet(menu)) {
            menu := item.menu
        }
        if (!isSet(clickhandler)) {
            clickhandler := item.menu
        }
        this._drawSeperatorIfRequested(&menu)
        menu.add(item.text, clickhandler)
        this._drawIcon(&item, &icon, &menu)
        menu.isEmpty := false	; flag non-empty menus
    }

    _findItem(id, &recursionLayer := unset) {
        if (!isSet(recursionLayer)) {
            recursionLayer := this._LAYOUT	; recursion starts at the root of the definition
        }

        for item in recursionLayer.content {
            if (this._isValidItem(item) && item.id = id) {
                return item
            } else if (this._isSubmenuOrGroup(item)) {
                referencedItem := this._findItem(id, &item)
                if (referencedItem) {
                    return referencedItem
                }
            }
        }
        return false	; couldn't find item
    }

    _drawSeperatorIfRequested(&menu) {
        if (menu.hasOwnProp("isEmpty") && !menu.isEmpty) {	; menu is not empty
            if (menu.hasOwnProp("requestSeperator") && menu.requestSeperator) {
                menu.add()	; add a seperator line
                menu.requestSeperator := false
            }
        } else {	; menu is empty
            menu.requestSeperator := false
        }
    }

    /** Display the correct icon for a submenu or action
     * @param {Menu} menu - traymenu or submenu to which is drawn
     * @param {Object} item - action or submenu to apply the icon to
     * @param {string[2]/string} icon - icon to be applied, path or [path, index]
     */
    _drawIcon(&item, &icon, &menu) {
        if (icon is array) {	; icon contains a path and index
            menu.setIcon(item.text, icon[1], icon[2])
        } else if (icon is string) {	; icon only contains a path
            menu.setIcon(item.text, icon)
        }
    }

}

handler(itemName, itemPos, menu) {
    log("Clicked on tray:", "Text:`t" itemName, "Position:`t" itemPos, "Menu:`t" menu.name)
}