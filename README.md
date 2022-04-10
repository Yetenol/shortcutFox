# **shortcutFox** ![GitHub last commit](https://img.shields.io/github/last-commit/yetenol/shortcutFox?color=white)

This branch aims to learn the syntax of AutoHotkey v2 
and help to convert other AutoHotkey projects.

## Build instructions
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