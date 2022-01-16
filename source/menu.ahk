#Include trayItems.ahk

global TRAY_ITEMS

class TrayMenu {
    tray := A_trayMenu

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

    __New() {
        ; create submenu objects
        this.parseDefinition(TRAY_ITEMS)

        this.update()
    }

    /*****************************************************
        initialize Menu() objects for all submenus or groups
        - to display a submenu, items must be attached to an existing menu object
        - objects are stored inside the definition object
      @param actionList[]: array of items
    */
    parseDefinition(actionList) {
        for item in actionList
        {
            if (item.hasOwnProp("content"))
            { ; item is a submenu or group
                item.menu := Menu() ; create a new submenu object
                this.parseDefinition(item.content) ; parse all children of the submenu or group
            }
        }
    }

    getType(item) {
        itemType := TrayMenu.TYPES.ACTION ; default is action

        if (item.hasOwnProp("content"))
        { ; item is a group or submenu
            if (item.hasOwnProp("maxDisplay"))
            { ; a maximum number of displayed child items before using a submenu is set
                if (item.content.Length > item.maxDisplay)
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

    update() {
        this.tray.delete
        for item in TRAY_ITEMS {
            this.addItem(this.tray, item)
        }
    }

    addItem(menu, item) {
        switch this.getType(item) ; if type is omitted, set it to ACTION
        {
        case TrayMenu.TYPES.GROUP:
            menu.doLine := true ; remember to add a seperator line before the next item on this submenu level
            
            ; recursively parse all subitems
            for action in item.content {
                this.addItem(menu, action)
            }

        case TrayMenu.TYPES.SUBMENU:
            ; recursively parse all subitems
            for action in item.content {
                this.addItem(item.menu, action)
            }

            ; attach and display the submenu for the traymenu
            menu.add(item.text, item.menu)

        case TrayMenu.TYPES.LINE:
            menu.doLine := true ; remember to add a seperator line before the next item on this submenu level

        default: ; item in a proper action
            ; add a seperator line if requested previously
            if (menu.hasOwnProp("doLine") && menu.doLine) {
                menu.add() ; add a seperator line
                menu.doLine := false
            }

            ; attach and display the entry for the traymenu
            menu.add(item.text, handler)

            ; set the entry icon
            if (item.hasOwnProp("icon")) {
                if (item.hasOwnProp("iconIndex")) {
                    menu.setIcon(item.text, item.icon, item.iconIndex)
                } else {
                    menu.setIcon(item.text, item.icon)
                }
            }
        }
    }

}

handler(*) {
    MsgBox("Clicked on tray")
}