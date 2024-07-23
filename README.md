# shortcutFox

[![Download script](https://img.shields.io/github/downloads/yetenol/shortcutFox/total.svg)](https://github.com/yetenol/shortcutFox/releases/latest/download/shortcutFox.exe)
[![List releases](https://img.shields.io/github/release/yetenol/shortcutFox.svg)](https://github.com/yetenol/shortcutFox/releases)

shortcutFox adds a menu to the system tray that contains frequently used actions, update scripts and settings for keyboard shortcuts. 
With a [human readable configuration file](source/config/trayShortcuts.ahk) the menu can be edited or additional actions can be added.

# Features

![Usage example](example.png)

## Keyboard shortcuts

Change **word case** in [editors](#whitelisted-apps-to-toggle-word-case). `[CapsLock]`

Pop up **KeeWeb**
- Lookup credentials. `[Win + Shift + V]`
- Fill in credentials on websites. `[Ctrl + Shift + V]`

Insert the date formatted as YYYY-MM-DD. `[Win + Alt + D]`

Quick launch with PowerToys Run instead of Windows Search. `[Win]`

## Tray shortcuts

Push and pull and **repositories**
- Finds all repositories
- Pushes and pulls all branches that exist locally and remotely
- Shows progress in a terminal window
- Only fast-forwards the pulls

Upgrade **applications**
- Installs software upgrades via winget
- Shows progress in a terminal window
- Prompts to runs as administrator

Apply reddit **wallpaper**
- Applies image as desktop background
- Downloads best image post from r/wallpaper subreddit
- Stores the image in a Pictures subfolder

Setup face recognition
- Setup Windows Hello (again) to improve face recognition

Add a fingerprint
- Add a fingerprint to Windows Hello

Transfer files via Bluetooth
- Start Bluetooth File Transfer wizard

Recalibrate the **digital pen**
- Useful for convertible laptops

Select area to **screenshot**
- Start Snipping Tool area selection


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

# Build an executable yourself

Install dependency **[AutoHotkey v2](https://www.autohotkey.com/)** by running
```powershell
winget install -e AutoHotkey.AutoHotkey --scope machine
```

Install dependency **[Ahk2Exe Compiler](https://www.autohotkey.com/docs/v2/Scripts.htm#ahk2exe)** by executing
```
%ProgramFiles%\AutoHotkey\UX\install-ahk2exe.ahk
```
- Or open *AutoHotkey Dash* and click `Compile`
- Confirm to download Ahk2Exe

**Build** an executable by pressing `[Ctrl+Shift+B]` to run [build task](.vscode\tasks.json) for VS Code or build using a terminal:
```powershell
& "$env:ProgramFiles\AutoHotkey\Compiler\Ahk2Exe.exe" /in source\main.ahk /out bin\shortcutFox.exe /icon source\icons\menu.ico /bin "$env:ProgramFiles\AutoHotkey\v2\AutoHotkey.exe"
```
```cmd
"%ProgramFiles%\AutoHotkey\Compiler\Ahk2Exe.exe" /in source\main.ahk /out bin\shortcutFox.exe /icon source\icons\menu.ico /bin "%ProgramFiles%\AutoHotkey\v2\AutoHotkey.exe"
```

**Start** shortcutFox from Windows Start or execute:
```powershell
.\bin\shortcutFox.exe
```
- Click `Reload` if prompted that the application is still running

# Develop and debug using Visual Studio Code

Install **code editor** [Visual Studio Code](https://code.visualstudio.com/)
```powershell
winget install -e Microsoft.VisualStudioCode --scope machine
```

Add **language support** [AutoHotkey v2 Language Support](vscode:extension/thqby.vscode-autohotkey2-lsp)
- [x] features IntelliSense for AutoHotkey's functions and your's
- [x] features Rename Symbol

Make sure that the debugger always executes the main source file and not the currently opened one. Disable `ahk2: Debug Script` and `ahk2: Debug Script with Params` keyboard shortcuts in `Keyboard Shortcuts (JSON)`:
```json
    {
        "key": "f5",
        "command": "-ahk2.debug",
        "when": "!inDebugMode && editorLangId == 'ahk2' && resourceScheme == 'file'"
    },
    {
        "key": "shift+f5",
        "command": "-ahk2.debug.params",
        "when": "editorLangId == 'ahk2' && resourceScheme == 'file'"
    },
```

Add **debugging adapter** [vscode-autohotkey-debug](vscode:extension/zero-plusplus.vscode-autohotkey-debug)
- [x] features Breakpoints

The [debug configuration file](.vscode\launch.json) specifies which source file is the main file to compile from.

# Credits

- Icons from [Icons8](https://icons8.com/icons/fluency)
- Converted to ICO using [Convertio](https://convertio.co/png-ico/)
