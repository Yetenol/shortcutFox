; ========================= Main Tray Actions ========================= 
TrayActions := []
TrayActions.Push( Array("Setup Hello Face", "SETUP_HELLO_FACE") )
TrayActions.Push( Array("Setup Hello Fingerprint", "SETUP_HELLO_FINGERPRINT") )
TrayActions.Push( Array("", "") ) ; Create a separator line.
TrayActions.Push( Array("Connect bluetooth device", "CONNECT_BLUETOOTH_DEVICE") )
TrayActions.Push( Array("Take Screenshot", "TAKE_SCREENSHOT") )


; ========================= Setup Tray Menu =========================
Menu, Tray, NoStandard
Menu, MANAGE_SCRIPT, Add, % "Suspend", SUSPEND
Menu, MANAGE_SCRIPT, Add, % "EXIT", EXIT
Menu, Tray, Add, % "Manage script...", :MANAGE_SCRIPT
Menu, SEND_KEYSTROKE, Add, % "Send Pause", SendPause
Menu, SEND_KEYSTROKE, Add, % "Send Ctrl+Pause", SendCtrlBreak
Menu, Tray, Add, % "Send keystroke...", :SEND_KEYSTROKE
Menu, Tray, Add ; Create a separator line.
for _, action in TrayActions
    Menu, Tray, Add, % action[1], % action[2]
Menu, Tray, Click, 1
;Menu, Tray, Default, % "Connect bluetooth device"
return



; ==================== Tray menu ====================
TAKE_SCREENSHOT:
    Send, {PrintScreen}
return

CONNECT_BLUETOOTH_DEVICE:
    Run, explorer ms-settings:connecteddevices
return

SETUP_HELLO_FINGERPRINT:
    Run, explorer ms-settings:signinoptions-launchfingerprintenrollment	
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