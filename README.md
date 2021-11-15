# **Window Tools** ![GitHub last commit](https://img.shields.io/github/last-commit/yetenol/window-tools?color=white)

[![Download script](https://img.shields.io/github/downloads/yetenol/Window-Tools/total.svg)](https://github.com/yetenol/Window-Tools/releases/latest/download/Window-Tools.exe)
[![List releases](https://img.shields.io/github/release/yetenol/Window-Tools.svg)](https://github.com/yetenol/Window-Tools/releases)

## Build instructions
- install depedency [AutoHotkey](https://www.autohotkey.com/download/ahk-install.exe)
    ```
    winget install -e --id Lexikos.AutoHotkey
    ```
- navigate to protect directory
- build using Powershell
    ```powershell
    $compilerPath = "$env:ProgramFiles\AutoHotkey\Compiler\Ahk2Exe.exe"
    & $compilerPath /in source/main.ahk /out bin\Window-Tools.exe /icon resources\Window-Tools.ico
    ```
- or build using CMD
    ```cmd
    set compilerPath=%ProgramFiles%\AutoHotkey\Compiler\Ahk2Exe.exe
    "%compilerPath%" /in source/main.ahk /out bin\Window-Tools.exe /icon resources\Window-Tools.ico
    ```