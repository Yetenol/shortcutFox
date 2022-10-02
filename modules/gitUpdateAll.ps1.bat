# & cls & powershell -NoExit -Command "Invoke-Command -ScriptBlock ([ScriptBlock]::Create(((Get-Content """%0""") -join [Environment]::NewLine)))" & exit
# Script is executable and persistent when renamed *.cmd or *.bat

$rootPath = "D:\"

Get-ChildItem -Path $rootPath -Directory -Recurse | 
% { $_.FullName } | 
? { Test-Path -Path "$_\.git" } |
% { 
    Write-Host "$_`t" -f Cyan -NoNewline
    git -C $_ pull --all
    git -C $_ push --all
}