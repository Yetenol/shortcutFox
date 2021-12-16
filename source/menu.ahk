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
        this.tray.delete
        this.update()
    }

    update() {
        for item in TRAY_ITEMS {
            this.addItem(this.tray, item)
        }
    }

    addItem(menu, item) {
        ; if type is omitted, set it to ACTION
        type := (item.hasOwnProp("type")) ? item.type : TrayMenu.TYPES.ACTION

        switch type 
        {
        case TrayMenu.TYPES.GROUP:
            this.addLine()
            for action in item.actions {
                this.addItem(menu, action)
            }

        case TrayMenu.TYPES.SUBMENU:
            submenu := this.tray
            for action in item.actions {
                this.addItem(submenu, action)
            }

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