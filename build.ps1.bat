# & cls & powershell -Command "Invoke-Command -ScriptBlock ([ScriptBlock]::Create(((Get-Content """%0""") -join """`n""")))" & exit
# The above line makes the script executable when renamed .cmd or .bat

$compiler = "$env:ProgramFiles\AutoHotkey 2\Compiler\Ahk2Exe.exe"
$ahk2 = "$env:ProgramFiles\AutoHotkey 2\AutoHotkey64.exe"
& $compiler /bin $ahk2 /in source/main.ahk /out bin\shortcutFox.exe