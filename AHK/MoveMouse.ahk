; Prevents the computer from sleeping or idling by moving the mouse cursor to different positions at different speeds at different intervals.
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

; Changes the priority of the script to High (H).
Process, Priority, , H

; Ensures a consistent starting directory.
SetWorkingDir %A_ScriptDir%


appDesc = 
(
Prevents the computer from sleeping or idling by moving the mouse cursor to different positions at different speeds at different intervals.

Author: kakaiba-talaga
License: GPL-3.0-or-later
Repository: https://github.com/kakaiba-talaga/AutoHotkey-Scripts
)

appTitle := "MoveMouse"
appVersion := "v1.2.4"
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

minTimeInterval := 5000
maxTimeInterval := 15000
median := GetMedian(minTimeInterval, maxTimeInterval)
samePosCount := 0

Loop
{
    isWindowsLocked := WindowsIsLocked()

    if (isWindowsLocked)
    {
        ; OutputDebug, Locked > Sleep: 10 seconds

        ; Pause before continuing the loop.
        Sleep, 10000

        continue
    }

    ; The time interval to determine when to do the mouse movement.
    Random, sleepInMSec, minTimeInterval, maxTimeInterval
    ; OutputDebug, Sleep: %sleepInMSec%

    ; Pause until the specified time.
    Sleep sleepInMSec

    isUserTyping := UserIsTyping()

    if (isUserTyping)
        continue

    MoveMouse()

    if ((samePosCount * 1) >= median)
    {
        isUserTyping := UserIsTyping()

        if (isUserTyping)
            continue

        SimulateKey()
    }

    ; OutputDebug, ------------------------------
}

; --------------------
; LABELS
; --------------------

AboutHandler:
    MsgBox, 64, %appTitle%, %appDesc%
    Return

; --------------------
; FUNCTIONS
; --------------------

; Move the mouse cursor to a random position and back.
MoveMouse()
{
    global samePosCount

    ; Get the mouse cursor's initial position.
    mousePos1 := GetMouseCursorPos()

    ; Random number of pixels to move the mouse cursor.
    Random, movePixels, 1, 10
    ; OutputDebug, Pixels: %movePixels%

    ; Random number to be used for the speed of the mouse movement. 1 = Fastest, 100 = Slowest
    Random, moveSpeed, 1, 9
    ; OutputDebug, Speed Movement: %moveSpeed%

    ; Pause before continuing.
    Sleep, 1000

    ; Get the mouse cursor's final position before moving it.
    mousePos2 := GetMouseCursorPos()

    ; Only move the mouse cursor if it's still at the initial position.
    if mousePos1.x = mousePos2.x and mousePos1.y = mousePos2.y
    {
        samePosCount += 1

        ; Move the mouse cursor to the right.
        MouseMove, movePixels, 0, moveSpeed, R

        ; Move the mouse back the original position.
        MouseMove, (movePixels * -1), 0, moveSpeed, R
    }
    else
        samePosCount := 0

    ; OutputDebug, Same Position Count: %samePosCount%
}

; The median between 2 numbers against a baseline (default: 180000 or 3 minutes).
GetMedian(n1, n2, baseLine := 180000)
{
    ; The median between 7 and 36.
    ;   3 minutes = 180,000 seconds
    ;   180,000 / 25,000 = 7.2 = 7
    ;   180,000 / 5,000 = 36
    ;   ((36 - 7) + 1) / 2 = 15

    if (n1 > n2)
        Return 0

    max := Round(baseLine / n1)
    min := Round(baseLine / n2)
    median := Round(((max - min) + 1) / 2)

    ; OutputDebug, Median: %median%
    ; OutputDebug, ---------------

    Return median * 1
}

; Returns the mouse cursors current position (X and Y axes),
;   the unique ID number of the window under the mouse cursor, and
;   the name (ClassNN) of the control under the mouse cursor (this will be blank if cannot be determined).
GetMouseCursorPos()
{
    MouseGetPos, xPos, yPos, uniqueId, controlName
    ; OutputDebug, Mouse Position: %xPos%, %yPos%

    Return {x: xPos, y: yPos, ahkId: uniqueId, classNN: controlName}
}

; Gets the executable name of the current active window.
GetWinExe()
{
    WinGet, ahkExe, ProcessName, A
    ; OutputDebug, Executable: %ahkExe%

    return Trim(ahkExe)
}

; This **should** trick any timers like in HubStaff that a key was pressed and won't report any idle time.
; Simulate some key presses.
SimulateKey()
{
    ; Specify which key presses are appliable.
    ; You can also specify specific key presses based on specific applications.

    ; Send {Shift 2}
    Send ^{Z}^{Y}
    ; OutputDebug, Simulated Key: Ctrl+Z, Ctrl+Y

    ; Specific key presses based on specific applications.
    ; ahkExe := GetWinExe()

    ; if (ahkExe == "msedge.exe")
    ; {
    ;     Send {Up}
    ;     Send {Down}
    ; }
    ; else if (ahkExe == "chrome.exe")
    ; {
    ;     Send {Shift 2}
    ; }
    ; else if (ahkExe != "firefox.exe")
    ; {
    ;     Send {Alt 2}
    ; }
}

; Checks if the user is currently typing something.
UserIsTyping()
{
    ; Waits for the user to press any key (L1 = 1 character).
    ; Waits for just 1 second (T1 = 1 second).
    ; Ensures that the user's keystrokes are sent to the active window (V).
    ; Keys that produce no visible character such as the modifier keys, function keys, and arrow keys
    ;   are listed as End Keys so that they will be detected, too.
    Input, pressedKey, L1 T1 V, {LControl}{RControl}{LAlt}{RAlt}{LShift}{RShift}{LWin}{RWin}{AppsKey}{F1}{F2}{F3}{F4}{F5}{F6}{F7}{F8}{F9}{F10}{F11}{F12}{Left}{Right}{Up}{Down}{Home}{End}{PgUp}{PgDn}{Del}{Ins}{BS}{CapsLock}{NumLock}{PrintScreen}{Pause}

    If (ErrorLevel = "Timeout")
    {
        ; OutputDebug, Pressed Key: Timed out
        Return False
    }

    ; OutputDebug, The user is typing.
    ; OutputDebug, Pressed Key: %pressedKey%

    Return True
}

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

    ; OutputDebug, Locked: %isLocked%

    Return isLocked
}
