#Include trayItems.ahk

global TRAY_ITEMS

class TrayMenu {
    tray := A_trayMenu ; Menu() object for the script's tray icon
    isEmpty := true

    static TYPES := {
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
        LINE: 3, 
        ;   - draws a seperator line
    }

    /** Constructor
    */
    __New() {
        this.parseDefinition(TRAY_ITEMS)
        this.update()
    }

    /** Initialize {Menu} objects for all submenus or groups.
        - to display a submenu, items must be attached to an existing menu object
        - objects are stored inside the definition object
        @param {Object[]} [parent] - array of items to recursively parse through
     */
    parseDefinition(parent) {
        for item in parent
        {
            if (item.hasOwnProp("content"))
            { ; item is a submenu or group
                item.menu := Menu() ; create a new submenu object
                this.parseDefinition(item.content) ; parse all children of the submenu or group
            }
        }
    }

    /** Get the type of an item.
        - returns a {TrayMenu.TYPES} value
        @param {Object} item - item of interest
     */
    getType(item) {
        itemType := TrayMenu.TYPES.ACTION ; default is action

        if (item.hasOwnProp("content"))
        { ; item is a group or submenu
            if (item.hasOwnProp("maxDisplay"))
            { ; a maximum number of displayed child items before using a submenu is set
                if (item.maxDisplay != -1 && item.content.Length > item.maxDisplay)
                { ; too many child items => display a submenu
                    return TrayMenu.TYPES.SUBMENU
                }
                else 
                { ; not too many child items => display a group
                    return TrayMenu.TYPES.GROUP
                }
            }
            else
            { ; no maximun number of displayed child items before using a submenu is set => display group
                return TrayMenu.TYPES.GROUP
            }
        }

    }

    /** Rerender the entire traymenu.
    */
    update() {
        this.clear(this.tray, TRAY_ITEMS)
        for item in TRAY_ITEMS {
            this.attachItem(this.tray, item)
        }
    }

    /** Clear the entire traymenu.
        @param {Menu} menu - traymenu or submenu to clear from
        @param {Object[]} parent - array of items to recursively search through
    */
    clear(menu, parent) {
        menu.delete()
        menu.isEmpty := true

        for item in parent
        {
            if (item.hasOwnProp("content") && item.content is array)
            { ; item contains children that are not linked
                this.clear(item.menu, item.content)
            }
        }
    }

    /** Attach an item to the traymenu or a submenu.
        @param {Menu} menu - traymenu or submenu to which is attached
        @param {item} item - group, submenu or action to attach
        @param {string} [icon=false] - icon to inherit from parent group of submenu
    */
    attachItem(menu, item, icon := false) {
        if (!icon && item.hasOwnProp("icon"))
        { ; no icon to inherit but this item has it's own icon
            icon := item.icon
        }
                
        switch this.getType(item)
        {
        case TrayMenu.TYPES.GROUP:           
            menu.doLine := true ; remember to add a seperator line before the next item on this submenu level
            this.attachContent(menu, item, icon)
            menu.doLine := true ; remember to add a seperator line before the next item on this submenu level

        case TrayMenu.TYPES.SUBMENU:
            this.attachContent(item.menu, item, icon)

            ; attach and display the submenu to the traymenu or another submenu
            this.drawLine(menu)
            menu.add(item.text, item.menu)
            menu.isEmpty := false ; flag non-empty menus

        case TrayMenu.TYPES.LINE:
            menu.doLine := true ; remember to add a seperator line before the next item on this submenu level

        default: ; item in a proper action
            ; attach and display the action to the traymenu or a submenu
            this.drawLine(menu)
            menu.add(item.text, handler)
            menu.isEmpty := false ; flag non-empty menus
            this.drawIcon(menu, item, icon)

        }
    }

    /** Attach all children to the traymenu or a submenu.
        @param {Menu} menu - traymenu or submenu to which is attached
        @param {item} item - group, submenu or action to attach
        @param {string} [icon=false] - icon to inherit from parent group of submenu
    */
    attachContent(menu, item, icon) {
        if (item.content is string)
        { ; content is linked => recursively attach linked content
            linkedContent := this.findItem(item.content)
            if (linkedContent)
            {
                for child in linkedContent
                {
                    this.attachItem(menu, child, icon)
                }
            } 
        }
        else if (item.content is array)
        { ; recursively attach all child items
            for child in item.content {
                this.attachItem(menu, child, icon)
            }
        }
    }

    /** return an item by id
        @param {string} id - id of the item of interest
        @param {Object[]} [parent=traymenu] - array of items to recursively search through
    */
    findItem(id, parent:=false) {
        if (!parent)
        { ; recursion start in the traymenu
            parent := this.tray
        }

        for item in parent
        {
            if (item.id = id) 
            {
                return item
            }
            else if (item.hasOwnProp("content") && item.content is array)
            { ; item contains children that are not linked
                this.findItem(item.id, item)   
            }
        }

        return false ; couldn't find item
    }

    /** Draw a seperator line if requested previously.
        @param {Menu} menu - traymenu or submenu to which is drawn
    */
    drawLine(menu) {
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
        @param {string[]/string} icon - icon to be applied
    */
    drawIcon(menu, item, icon) {
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

handler(*) {
    MsgBox("Clicked on tray")
}