# & cls & powershell -Command Start-Process wt -Verb RunAs -ArgumentList """PowerShell.exe -Command Invoke-Command -ScriptBlock ([ScriptBlock]::Create(((Get-Content %0) -join [Environment]::NewLine)))""" & exit
# Script is executable and self-elevating when renamed *.cmd or *.bat

powershell winget upgrade --all

@{
    AppData = 'AppData'; IECache = 'Cache'; IECookies = 'Cookies'; Desktop = 'Desktop'; Favorites = 'Favorites'; History = 'History'; LocalAppData = 'Local AppData'; Music = 'My Music'; Pictures = 'My Pictures'; Videos = 'My Video'; Documents = 'Personal'; Downloads = '{374DE290-123F-4565-9164-39C4925E467B}'; NetworkShortcuts = 'NetHood'; PrinterShortcuts = 'PrintHood'; Programs = 'Programs'; Recent = 'Recent'; SendTo = 'SendTo'; StartMenu = 'Start Menu'; Startup = 'Startup'; Templates = 'Templates'; CloudRoot = '{A52BBA46-E9E1-435F-B3D9-28DAA648C0F6}';
    SavedPictures = '{3B193882-D3AD-4EAB-965A-69829D1FB59F}'; CameraRoll = '{AB5FB87B-7CE2-4F83-915D-550846C9537B}'; Screenshots = '{B7BEDE81-DF94-4682-A7D8-57A52620B86F}'; LocalDocuments = '{F42EE2D3-909F-4907-8871-4C22FC0BF756}'; LocalDownloads = '{7D83EE9B-2244-4E70-B1F5-5393042AF1E4}'; LocalMusic = '{A0C69A99-21C8-4671-8703-7934162FCF1D}'; LocalPictures = '{0DDD015D-B06C-45D5-8C4C-F59713854639}'; LocalVideos = '{35286A68-3C57-41A1-BBB1-0EAE73D76C95}';
    CommonDownloads = '{3D644C9B-1FB8-4f30-9B45-F670235F79C0}'; CommonAppData = 'Common AppData'; CommonDesktop = 'Common Desktop'; CommonDocuments = 'Common Documents'; CommonPrograms = 'Common Programs'; CommonStartMenu = 'Common Start Menu'; CommonStartup = 'Common Startup'; CommonTemplates = 'Common Templates'; CommonMusic = 'CommonMusic'; CommonPictures = 'CommonPictures'; CommonVideos = 'CommonVideo';
} | % GetEnumerator | % {
    $namespace = $(if ($_.Value -like '{*}') {
        "shell:::" + $_.Value
    } else {
        "shell:" + $_.Value
    })
    try {
        [Environment]::SetEnvironmentVariable($_.Name, (New-Object -ComObject Shell.Application).NameSpace($namespace).Self.Path)
    } catch {}
}

Remove-Item "$env:Desktop\*.lnk", "$env:CommonDesktop\*.lnk"