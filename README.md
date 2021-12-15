# Test-AHK2

This projects aims to learn the syntax of AutoHotkey v2 
and help to convert by other AutoHotkey projects.

## Build instructions
- install depedency [AutoHotkey v2](https://www.autohotkey.com/v2/)
- navigate to protect directory
- build using Powershell
```powershell
$compiler = "$env:ProgramFiles\AutoHotkey 2.0\Compiler\Ahk2Exe.exe"
$ahk2 = "$env:ProgramFiles\AutoHotkey 2.0\AutoHotkey64.exe"
& $compiler /bin $ahk2 /in source/main.ahk /out bin\Window-Tools.exe
```