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
            if (!item.hasOwnProp("type") || item.type = TrayMenu.TYPES.ACTION) {
                ; item is an action
            } else if (item.type = TrayMenu.TYPES.GROUP) {
                ; item is a group
                this.addLine()
                for action in item.actions {
                    this.tray.add(action.text, handler)

                    if (action.hasOwnProp("icon")) {
                        if (action.hasOwnProp("iconIndex")) {
                            this.tray.setIcon(action.text, action.icon, action.iconIndex)
                        } else {
                            this.tray.setIcon(action.text, action.icon)
                        }
                    }
                }
            } else if (item.type = TrayMenu.TYPES.SUBMENU) {
                ; item is a submenu
            } else if (item.type = TrayMenu.TYPES.LINE) {
                ; item is a seperator line
                this.addLine()
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