$action = New-ScheduledTaskAction -Execute "Taskmgr.exe"
$trigger = New-ScheduledTaskTrigger -AtLogon
$principal = "Contoso\Administrator"
$settings = New-ScheduledTaskSettingsSet
$task = New-ScheduledTask -Action $action -Principal $principal -Trigger $trigger -Settings $settings
Register-ScheduledTask T1 -InputObject $task


$hourly_trigger = New-ScheduledTaskTrigger -Once -At 00:00 `
    -RepetitionInterval (New-TimeSpan -Hours 1)
$logon_trigger = New-ScheduledTaskTrigger -AtLogOn
$logon_trigger.Repetition = $hourly_trigger.Repetition
$hourly_after_logon_trigger = $logon_trigger


$action = New-ScheduledTaskAction -Execute 'powershell -File "D:\DEV\shortcutFox\source\scripts\applyRedditWallpaper.ps1"'

$settings = New-ScheduledTaskSettingsSet

$current_user = [Security.Principal.WindowsIdentity]::GetCurrent()
$principal = New-ScheduledTaskPrincipal $current_user.Name

$settings = New-ScheduledTaskSettingsSet

$task = New-ScheduledTask -Action $action -Principal $principal -Trigger $hourly_after_logon_trigger -Settings $settings
Register-ScheduledTask 'shortcutFox\test' -InputObject $task