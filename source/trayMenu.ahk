; ========================= Main Tray Actions ========================= 
trayActions := []
trayActions.Push( Array("Setup Hello Face", "SETUP_HELLO_FACE") )
trayActions.Push( Array("Setup Hello Fingerprint", "SETUP_HELLO_FINGERPRINT") )
trayActions.Push( Array("", "") ) ; Add a separator line.
trayActions.Push( Array("Connect bluetooth device", "CONNECT_BLUETOOTH_DEVICE") )
trayActions.Push( Array("Take Screenshot", "TAKE_SCREENSHOT") )

trayDefault :=  "TAKE_SCREENSHOT" ; set NONE for no default


; ========================= Setup Tray Menu =========================
; move the standard script control item to its own submenu
Menu, Tray, NoStandard
Menu, MANAGE_SCRIPT, Add, % "Suspend", SUSPEND
Menu, MANAGE_SCRIPT, Add, % "EXIT", EXIT
Menu, Tray, Add, % "Manage script...", :MANAGE_SCRIPT

; send special keystrokes used in other applications
Menu, SEND_KEYSTROKE, Add, % "Send Pause", SendPause
Menu, SEND_KEYSTROKE, Add, % "Send Ctrl+Pause", SendCtrlBreak                                                                                      
Menu, Tray, Add, % "Send keystroke...", :SEND_KEYSTROKE

; list all actions and link to their SET_DEFAULT_... label
Menu, DEFAULT_ACTION, Add, % "None", SET_DEFAULT_NONE
Menu, DEFAULT_ACTION, Add ; Add a separator line
for _, action in trayActions
    Menu, DEFAULT_ACTION, Add, % action[1], % "SET_DEFAULT_" action[2]
Menu, Tray, Add, % "Set left click action...", :DEFAULT_ACTION

; add all the main action
Menu, Tray, Add ; Add a separator line.
for _, action in trayActions
    Menu, Tray, Add, % action[1], % action[2]

; set action that runs when tray icon is left-clicked
Menu, Tray, Click, 1 ; just require a single click instead of a double click

if hasTrayDefault()
{ ; a default file was found
    Goto, % "SET_DEFAULT_" getTrayDefault()
} else {
    Goto, % "SET_DEFAULT_NONE"
}


return



; ==================== Tray menu ====================
SET_DEFAULT_NONE:
    Menu, Tray, NoDefault
    Menu, Tray, Icon, % A_WinDir "\System32\SHELL32.dll", 99 ; cascading windows icon
    if hasTrayDefault() { ; only set config if initialized
        setTrayDefault("NONE")
    }
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
    setTrayDefault("TAKE_SCREENSHOT")
return

CONNECT_BLUETOOTH_DEVICE:
    Run, explorer ms-settings:connecteddevices
return
SET_DEFAULT_CONNECT_BLUETOOTH_DEVICE:
    Menu, Tray, Default, % "Connect bluetooth device"
    Menu, Tray, Icon, % A_WinDir "\System32\netshell.dll", 104 ; bluetooth  *
    setTrayDefault("CONNECT_BLUETOOTH_DEVICE")
return


SETUP_HELLO_FINGERPRINT:
    Run, explorer ms-settings:signinoptions-launchfingerprintenrollment	
return
SET_DEFAULT_SETUP_HELLO_FINGERPRINT:
    Menu, Tray, Default, % "Setup Hello Fingerprint"
    Menu, Tray, Icon, % A_WinDir "\System32\sensorscpl.dll", 11 ; fingerprint scanner icon 
    setTrayDefault("SETUP_HELLO_FINGERPRINT")
return


SETUP_HELLO_FACE:
    Run, explorer ms-settings:signinoptions-launchfaceenrollment
return
SET_DEFAULT_SETUP_HELLO_FACE:
    Menu, Tray, Default, % "Setup Hello Face"
    Menu, Tray, Icon, % A_WinDir "\System32\ddores.dll", 87 ; face scanner icon
    setTrayDefault("SETUP_HELLO_FACE")
return



; ==================== MANAGE_SCRIPT submenu ====================
SUSPEND:
    Suspend
return

EXIT:
    ExitApp
return