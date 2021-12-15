#Include trayItems.ahk

global TRAY_ITEMS

class TrayMenu {
    tray := A_trayMenu

    static TYPE := {
        CATEGORY: 0,
        SUBMENU: 1,
    }

    __New() {
        this.tray.delete
        this.update()
    }

    update() {
        for category in TRAY_ITEMS {
            this.seperator()
            for action in category.actions {
                this.tray.add(action.text, handler)

                if (action.hasOwnProp("icon")) {
                    if (action.hasOwnProp("iconIndex")) {
                        this.tray.setIcon(action.text, action.icon, action.iconIndex)
                    } else {
                        this.tray.setIcon(action.text, action.icon)
                    }
                }
            }
        }
    }

    seperator() { ; Create a seperator line
        this.tray.add()
    }

}

handler(*) {
    MsgBox("Clicked on tray")
}