KEEWEB_PATH := "C:\Program Files\KeeWeb\KeeWeb.exe"
STARTUP_SHORTCUT := "C:\Users\anton\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup\shortcutFox.lnk"
DEFAULT_ICON := "icons\shortcut.ico"

/* ========== ICON TYPES =========
 * no icon: ""
 * use built-in checkmark icon: "CHECKMARK"
 * use icon from includeResourcs: "icons\..."
 * use icon from external path: "C:\FI\Config.ico""
 * use icon from bundle file (.dll): [FilePath, IconNumber] 
 * -> e.g. [A_WinDir "\System32\shell32.dll", 292]
 */
ICON_DISABLED_SWITCH := "icons\unchecked-checkbox.png"
ICON_ENABLED_SWITCH := "icons\checked-checkbox.png"
ICON_CHOOSEN_OPTION := "icons\filled-circle.png"
ICON_NOT_CHOOSEN_OPTION := "icons\unfilled-circle.png"