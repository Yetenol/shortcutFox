TRAY_LAYOUT := {
    id: "TRAYMENU",
    content:
        [{
            id: "EXIT",
            text: "Exit shortcutFox",
            call: "closeApp()",
        }, {
            id: "RUN_AT_STARTUP",
            text: "Run at startup",
            switch: false,
            call: "toggleRunAtStartup()",
        }, {
            id: "SEND_KEYSTROKES",
            text: "Send keystrokes",
            maxDisplay: 0,
            content:
                [{
                    id: "SEND_PAUSE",
                    text: "Send [Pause]",
                    delay: 2000,
                    send: "{Pause}",
                }, {
                    id: "SEND_CTRLBREAK",
                    text: "Send [Break]",
                    delay: 2000,
                    send: "{CtrlBreak}",
                },]
        }, {
            id: "SETTINGS",
            text: "Configure settings",
            content: [{
                id: "MANAGE_HOTKEYS",
                text: "Toggle keyboard shortcuts",
                maxDisplay: 0,
                content:
                    [{
                        id: "SUSPEND",
                        text: "Suspend all keyboard shortcuts",
                        switch: false,
                        call: "toggleSuspend()",
                    }, {
                        id: "TOGGLE_HOTKEYS",
                        text: "List of keyboard shortcuts",
                        content: [{
                            id: "HOTKEY_TOGGLE_CASE",
                            text: "Change word case [CapsLock]",
                            switch: false,
                        }, {
                            id: "HOTKEY_LAUNCH_KEEWEB",
                            text: "Lookup credentials [Win + Y]",
                            switch: true,
                        }, {
                            id: "HOTKEY_PASTE_KEEWEB",
                            text: "Fill in credentials [Ctrl + Shift + V]",
                            switch: true,
                        }, {
                            id: "HOTKEY_PASTE_DATE",
                            text: "Insert date [Win + Alt + D]",
                            switch: true,
                        }, {
                            id: "HOTKEY_WINKEY_STARTS_POWERTOYS_RUN",
                            text: "Open PowerToys Run [Win]",
                            switch: false,
                        }]
                    },]
            }, {
                id: "DEFAULT_ACTION",
                text: "Set left click action",
                maxDisplay: 0,
                icon: "",
                choice: "NO_DEFAULT_ACTION",
                call: "applyDefaultAction()",
                content:
                    [{
                        id: "NO_DEFAULT_ACTION",
                        text: "None",
                    },
                    "MAIN_SHORTCUTS",]
            },]
        }, {
            id: "MAIN_SHORTCUTS",
            text: "Main shortcuts",
            content:
                [{
                    id: "UPDATES",
                    text: "Application updates",
                    content:
                        [{
                            id: "SCHEDULE_ACTIONS",
                            text: "Run update actions periodically",
                            maxDisplay: 0,
                            icon: "",
                            content: [{
                                id: "NO_SCHEDULED_ACTIONS",
                                text: "Disable all schedules",
                            }, {
                                id: "SCHEDULE_WINGET_UPDATE",
                                text: "Weekly upgrade applications",
                                switch: false,
                            }, {
                                id: "SCHEDULE_GIT_UPDATE",
                                text: "Weekly update all repositories",
                                switch: false,
                            }, {
                                id: "SCHEDULE_REDDIT_WALLPAPER",
                                text: "Hourly apply reddit wallpaper",
                                switch: false,
                            },]
                        }, {
                            id: "WINGET_UPDATE",
                            text: "Upgrade &applications (run as admin)",
                            run: "scripts\wingetUpdateAll.ps1",
                            icon: "icons\software.png",
                        }, {
                            id: "GIT_UPDATE",
                            text: "Push and pull all &repositories",
                            run: "scripts\gitUpdateAll.ps1",
                            icon: "icons\git-compare.png",
                        }, {
                            id: "APPLY_REDDIT_WALLPAPER",
                            text: "Apply reddit &wallpaper",
                            run: "scripts\applyRedditWallpaper.ps1",
                            icon: "icons\wallpaper.png",
                        },]
                }, {
                    id: "WINDOWS_HELLO",
                    text: "Setup Windows Hello",
                    content:
                        [{
                            id: "SETUP_HELLO_FACE",
                            text: "Setup face recognition",
                            run: "explorer ms-settings:signinoptions-launchfaceenrollment",
                            icon: "icons\face-recognition.png",
                        }, {
                            id: "SETUP_HELLO_FINGERPRINT",
                            text: "Add a fingerprint",
                            run: "explorer ms-settings:signinoptions-launchfingerprintenrollment",
                            icon: "icons\fingerprint.png",
                        }, {
                            id: "BLUETOOTH_FILE_TRANSFER",
                            text: "Transfer files via Bluetooth",
                            icon: "icons\bluetooth.png",
                            run: "fsquirt",
                        },]
                }, {
                    id: "CONVERTIBLE",
                    text: "Pen & touch screen utilities",
                    content:
                        [{
                            id: "CALIBRATE_DIGITIZER",
                            text: "Calibrate pen",
                            run: "tabcal",
                            icon: "icons\pen.png",
                        }, {
                            id: "TAKE_SCREENSHOT",
                            text: "Select area to screenshot",
                            send: "#+s",
                            icon: "icons\screenshot.png",
                        },]
                },
            ]
        }
    ]
}