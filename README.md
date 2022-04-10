# **shortcutFox** ![GitHub last commit](https://img.shields.io/github/last-commit/yetenol/shortcutFox?color=white)

[![Download script](https://img.shields.io/github/downloads/yetenol/shortcutFox/total.svg)](https://github.com/yetenol/shortcutFox/releases/latest/download/shortcutFox.exe)
[![List releases](https://img.shields.io/github/release/yetenol/shortcutFox.svg)](https://github.com/yetenol/shortcutFox/releases)

## Features
### Keyboard modifications
- always use digits on NumPad (force enable NumLock)
### Tray Shortcuts
- right click the tray icon:
    - take screenshot
    - calibrate pen
    - connect to a bluetooth device
    - transfer files using bluetooth
    - setup Windows Hello Face
    - setup Windows Hello Fingerprint
- left click the tray:
    - execute the default action
    - configurable through the tray menu `Set left click action`
### Media control
- skip/rewind in Netflix/Primevideo using bluetooth speaker buttons
- tested on JBL bluetooth speakers
### Touchpad gestures
- add touchpad close gesture
    - No key pressed: close current tab if app supports it <br> otherwise close window
    - Shift pressed: close all tabs / entire window
    - Ctrl pressed: close all windows of this application
- add touchpad open gesture
    - Open new tab if current app supports it <br> otherwise open Action Center
### Window manipulation
- `[Win + End]` pin current window to alwaysontop
    - to unpin press `[Win + Shift + End]`
- 
### Patch script
- `[Win + F5]` Restart StartMenu process
- `[Win + Shift + F5]` Restart Explorer process

## Build instructions
- install depedency [AutoHotkey](https://www.autohotkey.com/download/ahk-install.exe)
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