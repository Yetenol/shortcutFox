# shortcutFox

[![Download script](https://img.shields.io/github/downloads/yetenol/shortcutFox/total.svg)](https://github.com/yetenol/shortcutFox/releases/latest/download/shortcutFox.exe)
[![List releases](https://img.shields.io/github/release/yetenol/shortcutFox.svg)](https://github.com/yetenol/shortcutFox/releases)

ShortcutFox lists shortcuts, which can be easily customized with a [json-like file](source/config/trayLayout.ahk), in the context menu of a system tray icon. Additionally, a few personalization tweaks are applied.

# Features

## Keyboard shortcuts

- Toggle **word case** for  [whitelisted apps](#whitelisted-apps-to-toggle-word-case) using `[CapsLock]`
- Focus or launch **KeeWeb** using `[Win + Shift + V]` 
- Focus next window it [fancy zone](https://learn.microsoft.com/en-us/windows/powertoys/fancyzones) using `[Win + Mouse Wheel Up]`
- Focus previous window it [fancy zone](https://learn.microsoft.com/en-us/windows/powertoys/fancyzones) using `[Win + Mouse Wheel Down]`

## Tray shortcuts

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

## Whitelisted apps to toggle word case

- Microsoft **Word**

- Microsoft **PowerPoint**

-  **Files** from [Files Community](https://files.community/)

- Visual Studio **Code**  
  requiring [Change Case](https://marketplace.visualstudio.com/items?itemName=FinnTenzor.change-case)  
  with keybinding `[Shift + F3]` ← Change Word Case

- **Obsidian**   
  requiring [Toggle Case](https://obsidian.md/plugins?id=obsidian-toggle-case)  
  with hotkey `[Shift + F3]` ← Toggle Case: Toggle Case

# Build instructions

- install dependency **AutoHotkey v2**
  by running **[setup](https://www.autohotkey.com/download/ahk-v2.exe)**

- install dependency **ahk2exe Compiler**  
  by extracting the `Compiler` folder from [AutoHotkey v1](https://www.autohotkey.com/download/ahk.zip) _extract Compiler Folder_

- **build an executable** from the project folder  
  by packaging the Powershell script
	```powershell
	$compiler = "$env:ProgramFiles\AutoHotkey 2\Compiler\Ahk2Exe.exe"
	$ahk2 = "$env:ProgramFiles\AutoHotkey 2\AutoHotkey64.exe"
	& $compiler /bin $ahk2 /in source/main.ahk /out bin\shortcutFox.exe
	```

- **start** shortcutFox
  ```powershell
  .\bin\shortcutFox.exe
	```

- enable **run at startup** using  
  `right-click tray icon > Manage script... > Run at startup`  

# Credits

- Icons from [Icons8](https://icons8.com/icons/fluency)
- Converted to ICO using [Convertio](https://convertio.co/png-ico/)
