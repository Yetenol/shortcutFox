#Include TRAYMENU_LAYOUT.ahk
#Include core.ahk

class MenuManager {
    _LAYOUT := false ; imported definition of the layout
    _traymenu := A_trayMenu

    static TYPES :=
    { ; Enumeration for all types of items
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
        this._attachItem(this._traymenu, this._LAYOUT)
    }


    /** Print the current traymenu layout into a file
        @param {string} [filename=traymenu.txt] - file to override
    recursion internal:
        @param {Object[]} [recursionLayer=_LAYOUT] - array of items to recursively iterate through
        @param {int} [layerIndex=0] - position within the current recursionLayer
        @param {int} [first=false] - is it the first item of the current recursionLayer?
        @param {int} [last=false] - is it the last item of the current recursionLayer?
    */
    logAll(filename:="traymenu.txt", recursionLayer:=false, layerIndex:=0, first:=false, last:=false) {
        if (!recursionLayer)
        { ; start recursion at top level of layout definition
            if (fileExist(filename))
            { ; only delete if it exists
                fileDelete(filename)
            }
            recursionLayer := this._LAYOUT
        }

        indent := "" 
        loop layerIndex
        {
            indent  := indent  " "
        }


        if (first && last)
        {
            draw := "└"
        }
        else if (first)
        {
            draw := "├"
        }
        else if (last)
        {
            draw := "└"
        }
        else
        {
            draw := "├"
        }
        
        line := indent draw " " recursionLayer.id "`n"
                
        fileAppend(line, filename, "UTF-8")

        if (recursionLayer.hasOwnProp("content"))
        {
            max := recursionLayer.content.Length
            for i, item in recursionLayer.content
            {
                first := (i = 1)
                last := (i = max)
                this.logAll(filename, item, layerIndex + 1, first, last)
            }
        }
    }


    _parseLayout(&recursionLayer)
    { 
        logIfDebug("parseLayout", "layer:`t" recursionLayer.id, "content:`t" recursionLayer.content.Length)
        this._constructSubmenu(&recursionLayer)
        this._dissolveSymbolicLinks(&recursionLayer)
    }

    _constructSubmenu(&recursionLayer) {
        recursionLayer.menu := (recursionLayer.id = "TRAYMENU") ? this._traymenu : Menu()
        recursionLayer.menu.name := recursionLayer.id
    }


    _dissolveSymbolicLinks(&recursionLayer) {
        i := 1
        while (i <= recursionLayer.content.Length) ; Content length changed
        {
            item := recursionLayer.content[i]

            if (this._isSymbolicLink(item))
            {
                this._pasteReferencedContent(&item, &recursionLayer, i)
                i-- ; iterate through the newly pasted linked items as well
            }
            else if (this._isSubmenuOrGroup(item))
            {
                this._parseLayout(&item)
            }
            i++
        }
    }


    _isSymbolicLink(item) => item is string

    _isValidItem(item) => (item is object) && item.hasOwnProp("id")

    _isSubmenuOrGroup(item) => this._isValidItem(item) && item.hasOwnProp("content")

    _pasteReferencedContent(&item, &destinationLayer, itemPosition) {
        destinationLayer.content[itemPosition] := this._findItem(item)
    }

    _getItemType(item) => (this._isSubmenuOrGroup(item)) ? (this._doesMeetMaxDisplay(&item)) ? MenuManager.TYPES.GROUP : MenuManager.TYPES.SUBMENU : MenuManager.TYPES.ACTION

    _doesMeetMaxDisplay(&item) {
        if (!item.hasOwnProp("maxDisplay"))
        { ; no maximun number of displayed child items before using a submenu is set => display group
            return true
        }
        else if (item.maxDisplay = 0)
        {
            return false
        }
        else
        {
            return item.maxDisplay = -1 || item.content.Length <= item.maxDisplay
        }
    }


    clear(recursionLayer:=false) {
        if (!recursionLayer)
        { 
            recursionLayer := this._LAYOUT ; start recursion at top level of layout definition
        }
        recursionLayer.menu.delete()
        recursionLayer.menu.isEmpty := true

        for item in recursionLayer.content
        {
            if (this._isSubmenuOrGroup(&item))
            {
                this.clear(item)
            }
        }
    }



    /** Attach an item to the traymenu or a submenu.
        @param {Menu} menu - traymenu or submenu to which is attached
        @param {Object} item - group, submenu or action to attach
        @param {string} [icon=false] - icon to inherit from parent group of submenu
    */
    _attachItem(menu, item, icon:=false) {
        if (!icon && item.hasOwnProp("icon"))
        { ; no icon to inherit but this item has it's own icon
            icon := item.icon
        }
        
        ; MsgBox("attachItem`nitem:`t" item.id "`nmenu:`t" menu.name)

        switch this._getItemType(item)
        {
        case MenuManager.TYPES.GROUP:           
            menu.doLine := true ; remember to add a seperator line before the next item on this submenu level
            for child in item.content
            {
                this._attachItem(menu, child, icon)
            }
            menu.doLine := true ; remember to add a seperator line before the next item on this submenu level

        case MenuManager.TYPES.SUBMENU:
            for child in item.content
            {
                this._attachItem(item.menu, child, icon)
            }

            ; attach and display the submenu to the traymenu or another submenu
            this._drawLine(menu)
            menu.add(item.text, item.menu)
            this._drawIcon(menu, item, icon)
            menu.isEmpty := false ; flag non-empty menus

        default: ; item in a proper action
            ; attach and display the action to the traymenu or a submenu
            this._drawLine(menu)
            menu.add(item.text, handler)
            this._drawIcon(menu, item, icon)
            menu.isEmpty := false ; flag non-empty menus

        }
    }


    /** return an item by id
        @param {string} id - id of the item of interest
        @param {Object[]} [recursionLayer=_LAYOUT] - array of items to recursively search through
    */
    _findItem(id, recursionLayer:=false) {
        if (!recursionLayer)
        { ; recursion starts at the root of the definition
            recursionLayer := this._LAYOUT
        }

        for item in recursionLayer.content
        {
            if (item is object)
            { ; item is a proper item
                if (item.id = id)
                {
                    return item
                }
                else if (item.hasOwnProp("content"))
                {
                    item := this._findItem(id, item)
                    if (item)
                    { ; found a valid item
                        return item
                    }
                }
            } 
        }
        return false ; couldn't find item
    }


    /** Draw a seperator line if requested previously.
        @param {Menu} menu - traymenu or submenu to which is drawn
    */
    _drawLine(menu) {
        if (menu.hasOwnProp("isEmpty") && !menu.isEmpty)
        { ; menu is not empty
            if (menu.hasOwnProp("doLine") && menu.doLine) {
                menu.add() ; add a seperator line
                menu.doLine := false
            }
        }
        else
        { ; menu is empty
            menu.doLine := false
        }
    }

    /** Display the correct icon for a submenu or action
        @param {Menu} menu - traymenu or submenu to which is drawn
        @param {Object} item - action or submenu to apply the icon to
        @param {string[2]/string} icon - icon to be applied, path or [path, index]
    */
    _drawIcon(menu, item, icon) {
        if (icon is array)
        { ; icon contains a path and index
            menu.setIcon(item.text, icon[1], icon[2]) 
        }
        else if(icon is string)
        { ; icon only contains a path
            menu.setIcon(item.text, icon)
        }
        else
        { ; no icon is set
        }
    }

}

handler(itemName, itemPos, menu) {
    log("Clicked on tray:", "Text:`t" itemName, "Position:`t" itemPos, "Menu:`t" menu.name)
}