; Prevents the computer from sleeping or idling by moving the mouse cursor at a specified interval.
; This was inspired by the NoSleep (.Net) app by Mike Langford.

; Author: kakaiba-talaga
; License: GPL-3.0-or-later
; Repository: https://github.com/kakaiba-talaga/AutoHotkey-Scripts

; Keeps a script permanently running (that is, until the user closes it or ExitApp is encountered).
#Persistent

; Ensures a consistent starting directory.
SetWorkingDir %A_ScriptDir%


appTitle := "MoveMouse"
appDesc := "Prevents the computer from sleeping or idling by moving the mouse cursor at a specified interval."
appVersion := "v1.0.0"
appAuthor := "kakaiba-talaga"
appTitle := appTitle . " by " . appAuthor . " " . appVersion

sleepInterval := 30000

; Set the tooltip.
Menu, Tray, Tip, %appTitle%

Menu, Tray, Icon, MoveMouse.ico

; Creates a separator line.
Menu, Tray, Add

; Creates a new menu item.
Menu, Tray, Add, About, MenuHandler

; Run MoveMouse every X seconds.
SetTimer, MoveMouse, %sleepInterval%
return

MoveMouse:
    ; Move the mouse one pixel to the right.
    MouseMove, 1, 0, 1, R

    ; Move the mouse back one pixel.
    MouseMove, -1, 0, 1, R

    return

MenuHandler:
    MsgBox, 64, %appTitle%, %appDesc%
    return
