# **Window Tools** ![GitHub last commit](https://img.shields.io/github/last-commit/yetenol/window-tools?color=white)

## Build
Powershell
```powershell
$compilerPath = "$env:ProgramFiles\AutoHotkey\Compiler\Ahk2Exe.exe"
& $compilerPath /in Window-Tools.ahk /out bin\Window-Tools.exe /icon resources\Window-Tools.ico
```

Cmd
```cmd
set compilerPath=%ProgramFiles%\AutoHotkey\Compiler\Ahk2Exe.exe
"%compilerPath%" /in Window-Tools.ahk /out bin\Window-Tools.exe /icon resources\Window-Tools.ico
```

; Main control program to 
; - managed keyboard shortcuts
; - launches external programs