; Prevents the computer from sleeping or idling by moving the mouse cursor to different positions at different intervals.
; This was inspired by the NoSleep (.Net) app by Mike Langford.

; Author: kakaiba-talaga
; License: GPL-3.0-or-later
; Repository: https://github.com/kakaiba-talaga/AutoHotkey-Scripts

; Maximize Performance
#NoEnv ; Prevents empty variables from being looked up as potential environment variables
SetBatchLines -1 ; Run the script at maximum speed.
ListLines Off ; Omits subsequently-executed lines from the history.

; Keeps a script permanently running until the user closes it or ExitApp is encountered.
#Persistent

; Skips the dialog box and replaces the old instance automatically.
#SingleInstance Force

; Changes the priority of the script to High.
Process, Priority, , H

; Ensures a consistent starting directory.
SetWorkingDir %A_ScriptDir%


appDesc = 
(
Prevents the computer from sleeping or idling by moving the mouse cursor to different positions at different intervals.

This was inspired by the NoSleep (.Net) app by Mike Langford.
)

appTitle := "MoveMouse"
appVersion := "v1.2.0"
appAuthor := "kakaiba-talaga"
appTitle := appTitle . " by " . appAuthor . " " . appVersion

Menu, Tray, Tip, %appTitle%

; This can be commented out if you will be compiling this script. Otherwise, ensure that the icon is in the same directory as the script or executable.
; You can set the custom icon in the GUI of Script to EXE Converter (ahk2Exe for AutoHotkey).
; Menu, Tray, Icon, MoveMouse.ico

; Creates a separator line.
Menu, Tray, Add

; Creates a new menu item.
Menu, Tray, Add, About, AboutHandler

Loop {
    isLocked := WindowsIsLocked()
    ; OutputDebug, Locked: %isLocked%

    if (isLocked)
    {
        ; OutputDebug, Continue: True
        ; OutputDebug, Sleep: 10 seconds

        ; Pause before continuing the loop.
        Sleep, 10000

        continue
    }

    ; The time interval to determine when to do the mouse movement.
    Random, sleepInMSec, 5000, 30000
    ; OutputDebug, Sleep: %sleepInMSec%

    ; Pause until the specified time.
    Sleep sleepInMSec

    MoveMouse()
}

; Move the mouse cursor to a random position and back.
MoveMouse()
{
    ; Random number of pixels to move the mouse cursor. From 1 through 10.
    Random, movePixels, 1, 10
    ; OutputDebug, Pixels: %movePixels%

    ; Move the mouse cursor to the right.
    MouseMove, movePixels, 0, 1, R

    ; Move the mouse back the original position.
    MouseMove, (movePixels * -1), 0, 1, R
}

AboutHandler:
    MsgBox, 64, %appTitle%, %appDesc%
    return

; Check if Windows has been locked by the user.
WindowsIsLocked()
{
    static WTS_CURRENT_SERVER_HANDLE := 0, WTSSessionInfoEx := 25, WTS_SESSIONSTATE_LOCK := 0x00000000, WTS_SESSIONSTATE_UNLOCK := 0x00000001 ;, WTS_SESSIONSTATE_UNKNOWN := 0xFFFFFFFF
    isLocked := False

    if (DllCall("ProcessIdToSessionId", "UInt", DllCall("GetCurrentProcessId", "UInt"), "UInt*", sessionId) && DllCall("wtsapi32\WTSQuerySessionInformation", "Ptr", WTS_CURRENT_SERVER_HANDLE, "UInt", sessionId, "UInt", WTSSessionInfoEx, "Ptr*", sesInfo, "Ptr*", BytesReturned))
    {
        SessionFlags := NumGet(sesInfo+0, 16, "Int")

        ; Windows Server 2008 R2 and Windows 7: Due to a code defect, the usage of the WTS_SESSIONSTATE_LOCK and WTS_SESSIONSTATE_UNLOCK flags are reversed.
        isLocked := A_OSVersion != "WIN_7" ? SessionFlags == WTS_SESSIONSTATE_LOCK : SessionFlags == WTS_SESSIONSTATE_UNLOCK

        DllCall("wtsapi32\WTSFreeMemory", "Ptr", sesInfo)
    }

    return isLocked
}
