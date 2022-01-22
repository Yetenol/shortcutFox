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

    /** 
     * Constructor and draw menu.
     */
    __New(&layout) {
        this._LAYOUT := layout
        this._parseLayout(&layout)
        this.update()
    }

    /** 
     * Rerender the entire menu.
     */
    update() {
        this.clear()
        this._attachItem()
    }

    /**
     * Deletes all menu entries.
     * @param recursionLayer INTERNAL - Definition layer to recursively parse through
     */
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

    /** 
     * Print the current traymenu layout into a file.
     * @param filename File to override
     * @param recursionLayer Definition layer to recursively parse through
     * @param layerIndex Position within the current layer
     * @param first Is it the first item of the current recursionLayer?
     * @param last Is it the last item of the current recursionLayer?
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

    /**
     * Prepare menu for initialization:
     * - Construct submenu objects to which the entries will be attached.
     * - Replace symbolic links with a copy of their referenced item, submenu or group.
     * @param recursionLayer Definition layer to recursively parse through
     */
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

    /**
     * Construct submenu objects to which the entries will be attached.
     * @param layer Layout level whose menu is to be created
     */
    _constructSubmenu(&layer) {
        layer.menu := (layer.id = "TRAYMENU") ? this._traymenu : Menu()
        layer.menu.name := layer.id
    }

    /**
     * If necessary, dissolve the link in its content.
     * @param item Possible symbolic link
     */
    _dissolveSymbolicLinks(&item, &destinationLayer, position) {
        if (this._isSymbolicLink(item)) {
            this._pasteReferencedContent(&item, &destinationLayer, position)
        }
    }

    /**
     * Is the item a symbolic link to another submenu or group?
     * @param item Action, submenu, group or symbolic link to examine
     */
    _isSymbolicLink(item) => item is string

    /**
     * Does the item fullfill the minimum specifications for a menu entry?
     * @param item Action, submenu, group or symbolic link to examine
     */
    _isValidItem(item) => (item is object) && item.hasOwnProp("id")

    /**
     * Does the element contain children, which is true for submenus and groups?
     * @param item Action, submenu, group or symbolic link to examine
     */
    _isSubmenuOrGroup(item) => this._isValidItem(item) && item.hasOwnProp("content")

    /**
     * Replace the symbolic link with a copy of its referenced item, submenu or group
     * @param linkItem Symbolic link item to replace
     * @param destinationLayer Layer of the symbolic link
     * @param itemPosition Position within the layer
     */
    _pasteReferencedContent(&linkItem, &destinationLayer, itemPosition) {
        destinationLayer.content[itemPosition] := this._findItem(linkItem)
    }

    /**
     * Return get type of an item
     * @param item Action, submenu or group to examine
     * @returns ({MenuManager.TYPES.} SUBMENU, GROUP or ACTION) or false if invalid
     */
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
     * Add the element to the specified menu.
     * @param item Action, submenu or group to attach
     * @param recursionMenu Menu to which is attached
     * @param inheritIcon Inherited icon from the parent level
     */
    _attachItem(&item := unset, &inheritIcon := false, &recursionMenu := unset) {
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

    /**
     * Add all children of an item to the specified menu.
     * @param item Submenu or group containing the children
     * @param inheritIcon Inherited icon from the parent level
     * @param destinationMenu Menu to which is attached
     */
    _attachChildren(&item, &inheritIcon, &destinationMenu := unset) {
        if (!isSet(destinationMenu)) {
            destinationMenu := item.menu
        }

        if (this._isSubmenuOrGroup(item)) {
            for child in item.content {
                this._attachItem(&child, &inheritIcon, &destinationMenu)
            }
        }
    }

    /**
     * Draw the entry into the specified menu.
     * @param item Item to draw
     * @param icon Icon to draw
     * @param menu Menu on which is drawn
     * @param clickhandler Function to run or Submenu to open when clicked
     */
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

    /**
     * Find an item by its id.
     * @param id Target's id
     * @param recursionLayer INTERNAL - Layout level to recursively search through
     */
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

    /**
     * Draw a seperator line if this has been requested beforehand.
     * @param menu Menu to examine
     */
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

    /** 
     * Draw the specified icon into a submenu or action
     * @param item Item to draw into
     * @param icon path or [path, index] to apply
     * @param menu - traymenu or submenu to which is drawn
     */
    _drawIcon(&item, &icon, &menu) {
        if (icon is array) {	; icon contains a path and index
            menu.setIcon(item.text, icon[1], icon[2])
        } else if (icon is string) {	; icon only contains a path
            menu.setIcon(item.text, icon)
        }
    }

}

/**
 * Display debugging information about the clicked entry.
 * @param itemName Entry's text
 * @param itemPosition Entry's position within its submenu
 * @param menu Entry's submenu or traymenu
 */
handler(itemName, itemPosition, menu) {
    log("Clicked on tray:", "Text:`t" itemName, "Position:`t" itemPosition, "Menu:`t" menu.name)
}