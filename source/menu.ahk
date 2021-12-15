#Include trayItems.ahk

global TRAY_ITEMS

class TrayMenu {
    tray := A_trayMenu

    __New() {
        this.tray.delete
        this.update()
    }

    update() {
        for category in TRAY_ITEMS {
            this.tray.add(category.text, handler)
        }
    }

}

handler(*) {
    MsgBox("Clicked on tray")
}