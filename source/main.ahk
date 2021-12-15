#SingleInstance force ; Override existing instance when lauched again
SetWorkingDir(A_ScriptDir) ; Ensures a consistent working directory (script folder)
MsgBox(A_WorkingDir)