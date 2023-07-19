$is_executed_privileged = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).
    IsInRole([Security.Principal.WindowsBuiltInRole]::"Administrator")
if (-not $is_executed_privileged) {
    if ((Get-Command wt.exe) -ne $null) {
        Start-Process wt "powershell -File $PSCommandPath -ExecutionPolicy Bypass" -Verb RunAs
    }
    else {
        Start-Process powershell "-File $PSCommandPath -ExecutionPolicy Bypass" -Verb RunAs
    }
    exit
}

Write-Host "Fetching application updates...`n"

# Import known folder
$env:CommonDesktop = (New-Object -ComObject Shell.Application).NameSpace('shell:Common Desktop').Self.Path
$env:Desktop = (New-Object -ComObject Shell.Application).NameSpace('shell:Desktop').Self.Path

# Update all winget applications
winget upgrade --all

# Remove any shortcuts placed on the desktop
Remove-Item "$env:Desktop\*.lnk", "$env:CommonDesktop\*.lnk"