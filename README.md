# **shortcutFox** ![GitHub last commit](https://img.shields.io/github/last-commit/yetenol/shortcutFox?color=white)

[![Download script](https://img.shields.io/github/downloads/yetenol/shortcutFox/total.svg)](https://github.com/yetenol/shortcutFox/releases/latest/download/shortcutFox.exe)
[![List releases](https://img.shields.io/github/release/yetenol/shortcutFox.svg)](https://github.com/yetenol/shortcutFox/releases)


## Features

### Application shortcuts
- `[Win + Shift + V]` Focus or launch KeeWeb

### Keyboard modifications
- always use digits on NumPad (force enable NumLock)

### Tray Shortcuts
- Right click the tray icon:
    - Enable run at startup _< `#Manage script...` submenu_
    - Take screenshot
    - Calibrate pen
    - Connect to a bluetooth device
    - Transfer files using bluetooth
    - Setup Windows Hello Face
    - Setup Windows Hello Fingerprint
- Left click the tray:
    - Execute the default action
    - Configurable _< `Set left click action...` submenu_

### Media control
- Skip/rewind in Netflix/Primevideo using bluetooth speaker buttons
- Tested on JBL bluetooth speakers

### Touchpad gestures
- Add touchpad close gesture
    - No key pressed: close current tab if app supports it <br> otherwise close window
    - Shift pressed: close all tabs / entire window
    - Ctrl pressed: close all windows of this application
- Add touchpad open gesture
    - Open new tab if current app supports it <br> otherwise open Action Center

### Window manipulation
- `[Win + End]` Pin current window to alwaysontop
    - To unpin press `[Win + Shift + End]`

### Patch script
- `[Win + F5]` Restart StartMenu process
- `[Win + Shift + F5]` Restart Explorer process


## Build instructions

- install dependency [AutoHotkey](https://www.autohotkey.com/download/ahk-install.exe)
    ```
    winget install -e --id Lexikos.AutoHotkey
    ```
- navigate to protect directory
- build using Powershell
```powershell
$compilerPath = "$env:ProgramFiles\AutoHotkey\Compiler\Ahk2Exe.exe"
& $compilerPath /in source/main.ahk /out bin\shortcutFox.exe /icon resources\ScreenSketch.ico
```
- or build using CMD
```cmd
set compilerPath=%ProgramFiles%\AutoHotkey\Compiler\Ahk2Exe.exe
"%compilerPath%" /in source/main.ahk /out bin\shortcutFox.exe /icon resources\ScreenSketch.ico
```