TRAY_LAYOUT := {
    id: "TRAYMENU",
    content:
        [{
            id: "MANAGE_SCRIPT",
            text: "Manage script...",
            maxDisplay: 0,
            content:
                [{
                    id: "RUN_AT_STARTUP",
                    text: "Run at startup",
                    switch : false,
                    call: "toggleRunAtStartup()",
                },
                {
                    id: "SUSPEND",
                    text: "Suspend",
                    switch : false,
                    call: "toggleSuspend()",
                },
                {
                    id: "EXIT",
                    text: "Exit",
                    call: "closeApp()",
                },]
            },
            {
                id: "MANAGE_HOTKEYS",
                text: "Manage keyboard shortcuts...",
                maxDisplay: 0,
                content:
                [{
                        id: "HOTKEY_TOGGLE_CASE",
                        text: "Change word case using [CapsLock]",
                        switch : false,
                    }, {
                        id: "HOTKEY_LAUNCH_KEEWEB",
                        text: "Focus or launch KeeWeb using [Win + Shift + V]",
                        switch : true,
                    }, {
                        id: "HOTKEY_CYCLE_ZONE_WINDOW",
                        text: (
                            "Cycle window in zone using "
                            "[Win + Mouse Wheel Up] or [Win + Mouse Wheel Down]"
                        ),
                        switch : true,
                    }
                ]
            },
            {
                id: "SEND_KEYSTROKES",
                text: "Send keystrokes...",
                maxDisplay: 0,
                content:
                    [{
                        id: "SEND_PAUSE",
                        text: "Send Pause",
                        delay: 2000,
                        send: "{Pause}",
                    }, {
                        id: "SEND_CTRLBREAK",
                        text: "Send Break",
                        delay: 2000,
                        send: "{CtrlBreak}",
                    },
                ]
            },
            {
                id: "DEFAULT_ACTION",
                text: "Set left click action",
                maxDisplay: 0,
                icon: "*",
                choice: "NO_DEFAULT_ACTION",
                call: "applyDefaultAction()",
                content:
                    [{
                        id: "NO_DEFAULT_ACTION",
                        text: "None",
                    },
                    "MAIN_SHORTCUTS",
                ]
            },
            {
                id: "MAIN_SHORTCUTS",
                text: "Main shortcuts",
                content:
                    [{
                        id: "WINDOWS_HELLO",
                        text: "Setup Windows Hello",
                        content:
                            [{
                                id: "SETUP_HELLO_FACE",
                                text: "Setup Hello Face",
                                run: "explorer ms-settings:signinoptions-launchfaceenrollment",
                                icon: "icons\face-id.ico",
                            }, {
                                id: "SETUP_HELLO_FINGERPRINT",
                                text: "Setup Hello Fingerprint",
                                run: "explorer ms-settings:signinoptions-launchfingerprintenrollment",
                                icon: "icons\add-fingerprint.ico",
                            },
                        ]
                    }, {
                        id: "BLUETOOTH",
                        text: "Bluetooth audio and file transfer",
                        maxDisplay: 1,
                        icon: "icons\bluetooth.ico",
                        content:
                            [{
                                id: "BLUETOOTH_FILE_TRANSFER",
                                text: "Transfer files using Bluetooth",
                                run: "fsquirt",
                            },
                        ]
                    }, {
                        id: "UPDATES",
                        text: "Application updates",
                        content:
                            [{
                                id: "WINGET_UPDATE",
                                text: "Update all applications",
                                run: "scripts\wingetUpdateAll.ps1",
                                icon: "icons\software-installer.ico",
                            }, {
                                id: "GIT_UPDATE",
                                text: "Update all repositories",
                                run: "scripts\gitUpdateAll.ps1",
                                icon: "icons\code-fork.ico",
                            },
                        ]
                    }, {
                        id: "CONVERTIBLE",
                        text: "Pen & touch screen utilities",
                        content:
                            [{
                                id: "CALIBRATE_DIGITIZER",
                                text: "Calibrate pen",
                                run: "tabcal",
                                icon: "icons\whiteboard.ico",
                            }, {
                                id: "TAKE_SCREENSHOT",
                                text: "Take Screenshot",
                                send: "#+s",
                                icon: "icons\windows-snipping-tool.ico",
                            },
                        ]
                    },
                ]
            }
        ]
    }