# **Window Tools** ![GitHub last commit](https://img.shields.io/github/last-commit/yetenol/window-tools?color=white)

[![Download script](https://img.shields.io/github/downloads/yetenol/Window-Tools/total.svg)](https://github.com/yetenol/Window-Tools/releases/latest/download/Export-UserProfile.ps1.bat)
[![List releases](https://img.shields.io/github/release/yetenol/Window-Tools.svg)](https://github.com/yetenol/Window-Tools/releases)

## Build
Powershell
```powershell
$compilerPath = "$env:ProgramFiles\AutoHotkey\Compiler\Ahk2Exe.exe"
& $compilerPath /in source/main.ahk /out bin\Window-Tools.exe /icon resources\Window-Tools.ico
```

Cmd
```cmd
set compilerPath=%ProgramFiles%\AutoHotkey\Compiler\Ahk2Exe.exe
"%compilerPath%" /in source/main.ahk /out bin\Window-Tools.exe /icon resources\Window-Tools.ico
```

; Main control program to 
; - managed keyboard shortcuts
; - launches external programs