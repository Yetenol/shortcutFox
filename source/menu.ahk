#Include trayItems.ahk

global TRAY_ITEMS

class TrayMenu {
    tray := A_trayMenu

    static TYPES := {
        ACTION: 0,  ; Default: type can be omitted
        GROUP: 1,
        SUBMENU: 2,
        LINE: 3,
    }

    __New() {
        ; create submenu objects
        for item in TRAY_ITEMS {
            this.newSubmenuObject(item)
        }

        this.update()
    }

    newSubmenuObject(item) {
        if (this.getType(item) = TrayMenu.TYPES.SUBMENU) {
            item.menu := Menu() ; Create a new submenu object
            for action in item.actions {
                this.newSubmenuObject(action)
            }
        }
    }

    ; if type is omitted, set it to ACTION
    getType(item) => (item.hasOwnProp("type")) ? item.type : TrayMenu.TYPES.ACTION 

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
            for action in item.actions {
                this.addItem(menu, action)
            }

        case TrayMenu.TYPES.SUBMENU:
            ; recursively parse all subitems
            for action in item.actions {
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