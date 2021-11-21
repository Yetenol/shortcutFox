; ========================= Main Tray Actions ========================= 
TrayActions := []
TrayActions.Push( Array("Setup Hello Face", "SETUP_HELLO_FACE") )
TrayActions.Push( Array("Setup Hello Fingerprint", "SETUP_HELLO_FINGERPRINT") )
TrayActions.Push( Array("", "") ) ; Add a separator line.
TrayActions.Push( Array("Connect bluetooth device", "CONNECT_BLUETOOTH_DEVICE") )
TrayActions.Push( Array("Take Screenshot", "TAKE_SCREENSHOT") )


; ========================= Setup Tray Menu =========================
Menu, Tray, NoStandard
Menu, MANAGE_SCRIPT, Add, % "Suspend", SUSPEND
Menu, MANAGE_SCRIPT, Add, % "EXIT", EXIT
Menu, Tray, Add, % "Manage script...", :MANAGE_SCRIPT

for _, action in TrayActions
    Menu, DEFAULT_ACTION, Add, % action[1], % "SET_DEFAULT_" action[2]
Menu, Tray, Add, % "Set left click action...", :DEFAULT_ACTION

Menu, SEND_KEYSTROKE, Add, % "Send Pause", SendPause
Menu, SEND_KEYSTROKE, Add, % "Send Ctrl+Pause", SendCtrlBreak
Menu, Tray, Add, % "Send keystroke...", :SEND_KEYSTROKE

Menu, Tray, Add ; Add a separator line.
for _, action in TrayActions
    Menu, Tray, Add, % action[1], % action[2]
Menu, Tray, Default, % "Connect bluetooth device"
Menu, Tray, Click, 1
return



; ==================== Tray menu ====================
SET_DEFAULT_TAKE_SCREENSHOT:
    Menu, Tray, Default, % "Take Screenshot"
return
TAKE_SCREENSHOT:
    Send, {PrintScreen}
return


SET_DEFAULT_CONNECT_BLUETOOTH_DEVICE:
    Menu, Tray, Default, % "Connect bluetooth device"
return
CONNECT_BLUETOOTH_DEVICE:
    Run, explorer ms-settings:connecteddevices
return


SET_DEFAULT_SETUP_HELLO_FINGERPRINT:
    Menu, Tray, Default, % "Setup Hello Fingerprint"
return
SETUP_HELLO_FINGERPRINT:
    Run, explorer ms-settings:signinoptions-launchfingerprintenrollment	
return


SET_DEFAULT_SETUP_HELLO_FACE:
    Menu, Tray, Default, % "Setup Hello Face"
return
SETUP_HELLO_FACE:
    Run, explorer ms-settings:signinoptions-launchfaceenrollment
return



; ==================== MANAGE_SCRIPT submenu ====================
SUSPEND:
    Suspend
return

EXIT:
    ExitApp
return