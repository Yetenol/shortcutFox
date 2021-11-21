; ========================= Main Tray Actions ========================= 
TrayActions := []
TrayActions.Push( Array("Setup Hello Face", "SETUP_HELLO_FACE") )
TrayActions.Push( Array("Setup Hello Fingerprint", "SETUP_HELLO_FINGERPRINT") )
TrayActions.Push( Array("", "") ) ; Add a separator line.
TrayActions.Push( Array("Connect bluetooth device", "CONNECT_BLUETOOTH_DEVICE") )
TrayActions.Push( Array("Take Screenshot", "TAKE_SCREENSHOT") )

defaultActionLabel :=  "TAKE_SCREENSHOT" ; set NONE for no default


; ========================= Setup Tray Menu =========================
; move the standard script control item to its own submenu
Menu, Tray, NoStandard
Menu, MANAGE_SCRIPT, Add, % "Suspend", SUSPEND
Menu, MANAGE_SCRIPT, Add, % "EXIT", EXIT
Menu, Tray, Add, % "Manage script...", :MANAGE_SCRIPT

; list all actions and link to their SET_DEFAULT_... label
Menu, DEFAULT_ACTION, Add, % "None", SET_DEFAULT_NONE
Menu, DEFAULT_ACTION, Add ; Add a separator line
for _, action in TrayActions
    Menu, DEFAULT_ACTION, Add, % action[1], % "SET_DEFAULT_" action[2]
Menu, Tray, Add, % "Set left click action...", :DEFAULT_ACTION

; send special keystrokes used in other applications
Menu, SEND_KEYSTROKE, Add, % "Send Pause", SendPause
Menu, SEND_KEYSTROKE, Add, % "Send Ctrl+Pause", SendCtrlBreak                                                                                      
Menu, Tray, Add, % "Send keystroke...", :SEND_KEYSTROKE

; add all the main action
Menu, Tray, Add ; Add a separator line.
for _, action in TrayActions
    Menu, Tray, Add, % action[1], % action[2]

; set action that runs when tray icon is left-clicked
Menu, Tray, Click, 1 ; just require a single click instead of a double click
Goto, % "SET_DEFAULT_" defaultActionLabel
return



; ==================== Tray menu ====================
SET_DEFAULT_NONE:
    Menu, Tray, NoDefault
    Menu, Tray, Icon, % A_WinDir "\System32\SHELL32.dll", 99 ; cascading windows icon
return


; launch snipping tool as long as accessibility settings is enable
; no enable set setting open ms-settings:easeofaccess-keyboard
; add enable `Use the PrtScn button to open screen snipping`
TAKE_SCREENSHOT:
    Send, {PrintScreen}
return
SET_DEFAULT_TAKE_SCREENSHOT:
    Menu, Tray, Default, % "Take Screenshot"
    Menu, Tray, Icon, * ; reset to included snipping tool icon
return

SET_DEFAULT_CONNECT_BLUETOOTH_DEVICE:
    Menu, Tray, Default, % "Connect bluetooth device"
    Menu, Tray, Icon, % A_WinDir "\System32\netshell.dll", 104 ; bluetooth  *
return
CONNECT_BLUETOOTH_DEVICE:
    Run, explorer ms-settings:connecteddevices
return


SET_DEFAULT_SETUP_HELLO_FINGERPRINT:
    Menu, Tray, Default, % "Setup Hello Fingerprint"
    Menu, Tray, Icon, % A_WinDir "\System32\sensorscpl.dll", 11 ; fingerprint scanner icon 
return
SETUP_HELLO_FINGERPRINT:
    Run, explorer ms-settings:signinoptions-launchfingerprintenrollment	
return


SET_DEFAULT_SETUP_HELLO_FACE:
    Menu, Tray, Default, % "Setup Hello Face"
    Menu, Tray, Icon, % A_WinDir "\System32\ddores.dll", 87 ; face scanner icon
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