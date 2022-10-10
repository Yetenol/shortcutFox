# & cls & powershell -Command Start-Process wt -Verb RunAs -ArgumentList """PowerShell.exe -Command Invoke-Command -ScriptBlock ([ScriptBlock]::Create(((Get-Content %0) -join [Environment]::NewLine)))""" & exit
# Script is executable and self-elevating when renamed *.cmd or *.bat

# Import known folder
$env:CommonDesktop = (New-Object -ComObject Shell.Application).NameSpace('shell:Common Desktop').Self.Path
$env:Desktop = (New-Object -ComObject Shell.Application).NameSpace('shell:Desktop').Self.Path

# Update all winget applications
winget upgrade --all

# Remove any shortcuts placed on the desktop
Remove-Item "$env:Desktop\*.lnk", "$env:CommonDesktop\*.lnk"