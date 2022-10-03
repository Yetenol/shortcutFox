# & cls & powershell -Command "Invoke-Command -ScriptBlock ([ScriptBlock]::Create(((Get-Content """%0""") -join [Environment]::NewLine)))" & exit
# Script is executable when renamed *.cmd or *.bat

# Import known folder
$env:Startup = (New-Object -ComObject Shell.Application).NameSpace('shell:Startup').Self.Path

$configFile = "$env:APPDATA\shortcutFox\RUN_AT_STARTUP.ini"
$shortcutPath = "$env:Startup\shortcutFox.lnk"
$executablePath = "D:\DEV\shortcutFox\bin\shortcutFox.exe"

$doStartup = Get-Content -Path $configFile -ErrorAction SilentlyContinue
if ($doStartup -eq "true") {
    Remove-Item -Path $shortcutPath -ErrorAction SilentlyContinue
    Set-Content -Path $configFile -Value "false"
} else {
    # Create startup shortcut
    $WshShell = New-Object -comObject WScript.Shell
    $Shortcut = $WshShell.CreateShortcut($shortcutPath)
    $Shortcut.TargetPath = $executablePath
    $Shortcut.Save()
    Set-Content -Path $configFile -Value "true"
}