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

        this.tray.delete
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
        for item in TRAY_ITEMS {
            this.addItem(this.tray, item)
        }
    }

    addItem(menu, item) {
        switch this.getType(item) ; if type is omitted, set it to ACTION
        {
        case TrayMenu.TYPES.GROUP:
            this.addLine()
            for action in item.actions {
                this.addItem(menu, action)
            }

        case TrayMenu.TYPES.SUBMENU:
            for action in item.actions {
                this.addItem(item.menu, action)
            }
            menu.add(item.text, item.menu)

        case TrayMenu.TYPES.LINE:
            this.addLine() ; add a seperator line

        default: ; item in an action
            menu.add(item.text, handler)
            if (item.hasOwnProp("icon")) {
                if (item.hasOwnProp("iconIndex")) {
                    menu.setIcon(item.text, item.icon, item.iconIndex)
                } else {
                    menu.setIcon(item.text, item.icon)
                }
            }
        }
    }

    addLine() { ; Create a seperator line
        this.tray.add()
    }

}

handler(*) {
    MsgBox("Clicked on tray")
}