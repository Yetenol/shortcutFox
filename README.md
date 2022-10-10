<h1> shortcutFox </h1>

[![Download script](https://img.shields.io/github/downloads/yetenol/shortcutFox/total.svg)](https://github.com/yetenol/shortcutFox/releases/latest/download/shortcutFox.exe)
[![List releases](https://img.shields.io/github/release/yetenol/shortcutFox.svg)](https://github.com/yetenol/shortcutFox/releases)

[⌂](README.md) Home

> ShortcutFox ia a shortcut menu for the system tray
> that can be easily modified using a [json-like file](source/trayLayout.ahk)

Table of Contents
- [Features](#features)
  - [Application shortcuts](#application-shortcuts)
    - [Tray Shortcuts](#tray-shortcuts)
- [Build instructions](#build-instructions)
- [Credits](#credits)

# Features
## Application shortcuts
- Focus or launch **KeeWeb**  
    `[Win + Shift + V]` 

### Tray Shortcuts
- Right click the tray icon:
    - Enable run at startup _< `#Manage script...` submenu_
    - Take screenshot
    - Calibrate pen
    - Update all repositories
    - Update all applications
    - Connect to a bluetooth device
    - Transfer files using bluetooth
    - Setup Windows Hello Face
    - Setup Windows Hello Fingerprint
- Left click the tray:
    - Execute the default action
    - Configurable _< `Set left click action...` submenu_

# Build instructions
- install depedencies
    - [AutoHotkey v2](https://www.autohotkey.com/download/ahk-v2.zip)
    - [ahk2exe Compiler](https://www.autohotkey.com/download/ahk.zip) _extract Compiler Folder_
- navigate to protect directory
- build using Powershell
```powershell
$compiler = "$env:ProgramFiles\AutoHotkey 2\Compiler\Ahk2Exe.exe"
$ahk2 = "$env:ProgramFiles\AutoHotkey 2\AutoHotkey64.exe"
& $compiler /bin $ahk2 /in source/main.ahk /out bin\shortcutFox.exe
```

# Credits

- Icons from [Icons8](https://icons8.com/icons/fluency)
- Converted to ICO using [Convertio](https://convertio.co/png-ico/)