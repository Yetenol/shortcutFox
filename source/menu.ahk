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
            this.addItem(item)
        }
    }

    addItem(item) {
        type := (item.hasOwnProp("type")) ? item.type : TrayMenu.TYPES.ACTION

        switch type 
        {
        case TrayMenu.TYPES.GROUP:
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
        case TrayMenu.TYPES.SUBMENU:
        case TrayMenu.TYPES.LINE:
            this.addLine() ; add a seperator line
        default: ; item in an action
        }
    }

    addLine() { ; Create a seperator line
        this.tray.add()
    }

}

handler(*) {
    MsgBox("Clicked on tray")
}