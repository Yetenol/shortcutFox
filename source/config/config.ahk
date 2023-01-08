KEEWEB_BIN := "C:\Program Files\KeeWeb\KeeWeb.exe"
STARTUP_SHORTCUT := "C:\Users\anton\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup\shortcutFox.lnk"
DEFAULT_ICON := "icons\shortcut.ico"

; ========== ICON TYPES =========
; no icon: ""
; checkmark: "CHECKMARK"
; icon from file: Path
; icon from icon group: [FilePath, IconNumber]
ICON_DISABLED_SWITCH := [A_WinDir "\System32\shell32.dll", 132]
ICON_ENABLED_SWITCH := [A_WinDir "\System32\shell32.dll", 295]
ICON_CHOOSEN_OPTION := [A_WinDir "\System32\shell32.dll", 292]
ICON_NOT_CHOOSEN_OPTION := ""