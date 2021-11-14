# **Window Tools** ![GitHub last commit](https://img.shields.io/github/last-commit/yetenol/window-tools?color=white)

## Build
Powershell
```powershell
# find compiler
if (Get-Command ahk2exe.exe -ErrorAction SilentlyContinue) {
    $compilerPath = "ahk2exe.exe"
} elseif (Get-Command "$env:ProgramFiles\AutoHotkey\Compiler\ahk2exe.exe" -ErrorAction SilentlyContinue) {
    $compilerPath = "$env:ProgramFiles\AutoHotkey\Compiler\ahk2exe.exe"
} else { 
    throw "Cannot find Ahk2exe compiler! Please install AutoHotkey first."
}

# build executable
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