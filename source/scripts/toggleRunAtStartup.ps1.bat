# & cls & powershell -Command "Invoke-Command -ScriptBlock ([ScriptBlock]::Create(((Get-Content """%0""") -join [Environment]::NewLine)))" & exit
# Script is executable when renamed *.cmd or *.bat

# Import known folder
$env:Startup = (New-Object -ComObject Shell.Application).NameSpace('shell:Startup').Self.Path

$shortcutPath = "$env:Startup\shortcutFox.lnk"
$executablePath = "D:\DEV\shortcutFox\bin\shortcutFox.exe"

if (Test-Path -Path $shortcutPath) {
    Remove-Item -Path $shortcutPath -ErrorAction SilentlyContinue
} else {
    # Create startup shortcut
    $WshShell = New-Object -comObject WScript.Shell
    $Shortcut = $WshShell.CreateShortcut($shortcutPath)
    $Shortcut.TargetPath = $executablePath
    $Shortcut.Save()
}