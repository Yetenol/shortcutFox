; ========================= Main Tray Actions ========================= 
actions := []
actions.Push({id: "SETUP_HELLO_FACE", text: "Setup Hello Face", run: "explorer ms-settings:signinoptions-launchfaceenrollment", icon: A_WinDir "\System32\ddores.dll", iconIndex: 87})
actions.Push({id: "SETUP_HELLO_FINGERPRINT", text: "Setup Hello Fingerprint", run: "explorer ms-settings:signinoptions-launchfingerprintenrollment", icon: A_WinDir "\System32\sensorscpl.dll", iconIndex: 99})
actions.Push({id: "-----"}) ; Add a separator line.
actions.Push({id: "BLUETOOTH_FILE_TRANSFER", text: "Transfer files using Bluetooth", run: "fsquirt", icon: A_WinDir "\System32\netshell.dll", iconIndex: 104})
actions.Push({id: "CONNECT_BLUETOOTH_DEVICE", text: "Connect bluetooth device", run: "explorer ms-settings:connecteddevices", icon: A_WinDir "\System32\netshell.dll", iconIndex: 104})
actions.Push({id: "-----"}) ; Add a separator line.
actions.Push({id: "CALIBRATE_DIGITIZER", text: "Calibrate pen", run: "tabcal"})
actions.Push({id: "TAKE_SCREENSHOT", text: "Take Screenshot", send: "{PrintScreen}", icon: "*"})

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
Menu, SET_DEFAULT_ACTION, Add, % "None", clearDefault
Menu, SET_DEFAULT_ACTION, Add ; Add a separator line
for _, item in actions {
    Menu, SET_DEFAULT_ACTION, Add, % item["text"], MENU_HANDLER
}
Menu, Tray, Add, % "Set left click action...", :SET_DEFAULT_ACTION

; add all the main action
Menu, Tray, Add ; Add a separator line.
for _, action in actions
    Menu, Tray, Add, % action["text"], MENU_HANDLER

; set action that runs when tray icon is left-clicked
Menu, Tray, Click, 1 ; just require a single click instead of a double click
applyTrayDefault()
return


applyTrayDefault() {
    if hasTrayDefault()
    { ; a config file was found
        loadedId =: loadTrayDefault()
        for _, item in actions {
            if (item["id"] = loadedId) {
                Menu, Tray, Default, % item["text"]
                return ; don't reset Icon
            }
        }
        clearIcon()
    } else {
        clearIcon()
    }
}


; ==================== Tray menu ====================
clearIcon() {
    Menu, Tray, Icon, % A_WinDir "\System32\SHELL32.dll", 99 ; cascading windows icon
}


clearDefault() {
    clearIcon()
    Menu, Tray, NoDefault
    saveTrayDefault("NONE")
}

MENU_HANDLER:
    if (A_ThisMenu = "Tray") {
        for index, item in actions {
            if (item["text"] = A_ThisMenuItem) {
                if (item["send"]) {
                    Send, % item["send"]
                }
                if (item["run"]) {
                    Run, % item["run"]
                }
                Break ; already found the right action
            }
        }
    } else if (A_ThisMenu = "SET_DEFAULT_ACTION") {
        for _, item in actions {
            if (item["text"] = A_ThisMenuItem) {
                Menu, Tray, Default, % item["text"]
                if (item["icon"]) {
                    Menu, Tray, Icon, % item["icon"], % item["iconIndex"]
                } else {
                    clearIcon()
                }
                saveTrayDefault(item["id"])
                Break
            }
        }   
    }
return



; launch snipping tool as long as accessibility settings is enable
; no enable set setting open ms-settings:easeofaccess-keyboard
; add enable `Use the PrtScn button to open screen snipping`
SET_DEFAULT_TAKE_SCREENSHOT:
    Menu, Tray, Default, % "Take Screenshot"
    Menu, Tray, Icon, * ; reset to included snipping tool icon
    saveTrayDefault("TAKE_SCREENSHOT")
return

SET_DEFAULT_CALIBRATE_DIGITIZER:
    Menu, Tray, Default, % "Calibrate pen"
    Menu, Tray, Icon, % A_WinDir "\System32\SHELL32.dll", 99 ; cascading windows icon
    saveTrayDefault("CALIBRATE_DIGITIZER")
return

SET_DEFAULT_CONNECT_BLUETOOTH_DEVICE:
    Menu, Tray, Default, % "Connect bluetooth device"
    Menu, Tray, Icon, % A_WinDir "\System32\netshell.dll", 104 ; bluetooth  *
    saveTrayDefault("CONNECT_BLUETOOTH_DEVICE")
return

SET_DEFAULT_BLUETOOTH_FILE_TRANSFER:
    Menu, Tray, Default, % "Transfer files using Bluetooth"
    Menu, Tray, Icon, % A_WinDir "\System32\netshell.dll", 104 ; bluetooth  *
    saveTrayDefault("BLUETOOTH_FILE_TRANSFER")
return

SET_DEFAULT_SETUP_HELLO_FINGERPRINT:
    Menu, Tray, Default, % "Setup Hello Fingerprint"
    Menu, Tray, Icon, % A_WinDir "\System32\sensorscpl.dll", 11 ; fingerprint scanner icon 
    saveTrayDefault("SETUP_HELLO_FINGERPRINT")
return

SET_DEFAULT_SETUP_HELLO_FACE:
    Menu, Tray, Default, % "Setup Hello Face"
    Menu, Tray, Icon, % A_WinDir "\System32\ddores.dll", 87 ; face scanner icon
    saveTrayDefault("SETUP_HELLO_FACE")
return



; ==================== MANAGE_SCRIPT submenu ====================
SUSPEND:
    Suspend
return

EXIT:
    ExitApp
return

