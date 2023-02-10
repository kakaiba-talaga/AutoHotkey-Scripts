; Prevents the computer from sleeping or idling by moving the mouse cursor to different positions at different speeds at different intervals.

; Author: kakaiba-talaga
; License: GPL-3.0-or-later
; Repository: https://github.com/kakaiba-talaga/AutoHotkey-Scripts

#Requires AutoHotkey >=2.0

; Omits subsequently-executed lines from the history.
ListLines false

; Enable warnings to assist with detecting common errors.
#Warn All, OutputDebug

; Ensures a consistent starting directory.
SetWorkingDir A_ScriptDir

; Skips the dialog box and replaces the old instance automatically.
#SingleInstance Force

; Changes the priority of the script to High.
ProcessSetPriority "High"

; Keeps a script permanently running until the user closes it or ExitApp is encountered.
Persistent true

; Ensures a consistent starting directory.
SetWorkingDir A_ScriptDir


appTitle := "MoveMouse"
appDesc := "Prevents the computer from sleeping or idling by moving the mouse cursor to different positions at different speeds at different intervals.`n`n" .
    "Author: kakaiba-talaga`n" .
    "License: GPL-3.0-or-later`n" .
    "Repository: https://github.com/kakaiba-talaga/AutoHotkey-Scripts"
appVersion := "v2.0.2-4"
appTitleLong := appTitle . " " . appVersion

; Set the Tray Icon tooltip.
A_IconTip := appTitleLong

; Set the TrayMenu object.
trayMenu := A_TrayMenu

; Remove the standard tray menus.
trayMenu.Delete

; Creates the About menu item.
trayMenu.Add "About", AboutHandler

; Exit the application.
A_TrayMenu.Add "Exit", ExitHandler


minTimeInterval := 5000
maxTimeInterval := 15000
median := GetMedian(minTimeInterval, maxTimeInterval)
samePosCount := 0

Loop
{
    ; The time interval to determine when to do the mouse movement.
    sleepInMSec := Random(minTimeInterval, maxTimeInterval)
    ; OutputDebug "Sleep: " . sleepInMSec

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

        SimulateKeypresses()
    }

    ; OutputDebug "------------------------------"
}

; --------------------
; MENU HANDLERS
; --------------------

AboutHandler(*)
{
    MsgBox appDesc, appTitleLong, 64
}

ExitHandler(*)
{
    ExitApp 0
}

; --------------------
; FUNCTIONS
; --------------------

; Move the mouse cursor to a random position and back.
MoveMouse()
{
    global samePosCount

    try
    {
        ; Get the mouse cursor's initial position.
        mousePos1 := GetMouseCursorPos()

        ; Random number of pixels to move the mouse cursor.
        movePixels := Random(1, 10)
        ; OutputDebug "Pixels: " . movePixels

        ; Random number to be used for the speed of the mouse movement. 1 = Fastest, 100 = Slowest
        moveSpeed := Random(1, 9)
        ; OutputDebug "Speed Movement: " . moveSpeed

        ; Pause before continuing.
        Sleep 1000

        ; Get the mouse cursor's final position before moving it.
        mousePos2 := GetMouseCursorPos()

        ; Only move the mouse cursor if it's still at the initial position.
        if (mousePos1.x = mousePos2.x and mousePos1.y = mousePos2.y)
        {
            samePosCount += 1

            ; Move the mouse cursor to the right.
            MouseMove movePixels, 0, moveSpeed, "R"

            ; Move the mouse back the original position.
            MouseMove (movePixels * -1), 0, moveSpeed, "R"
        }
        else
        {
            samePosCount := 0
        }
    }
    catch Error as e
    {
        ; There was an error. Do nothing.
    }

    ; OutputDebug "Same Position Count: " . samePosCount
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
        return 0

    xMax := Round(baseLine / n1)
    xMin := Round(baseLine / n2)
    xMedian := Round(((xMax - xMin) + 1) / 2)

    ; OutputDebug "Median: " . xMedian
    ; OutputDebug "---------------"

    return xMedian * 1
}

; Returns the mouse cursors current position (X and Y axes),
; the unique ID number of the window under the mouse cursor, and
; the name (ClassNN) of the control under the mouse cursor.
GetMouseCursorPos()
{
    MouseGetPos &xPos, &yPos, &uniqueId, &controlName
    ; OutputDebug "Mouse Position: " . xPos . ", " . yPos

    return {x: xPos, y: yPos, ahkId: uniqueId, classNN: controlName}
}

; Gets the executable name of the current active window.
GetWinExe()
{
    try {
        processExe := WinGetProcessName("A")
        ; OutputDebug "Executable: " . processExe
    }
    catch TargetError as e
    {
        return ""
    }

    return Trim(processExe)
}

; Simulate some keypresses.
; This **should** trick any timers like HubStaff that a key was pressed and won't report any idle time.
SimulateKeypresses()
{
    ; Specify which key presses are applicable.
    ; You can also specify specific key presses based on specific applications.

    ; Get the executable name of the currently focused application.
    winExe := GetWinExe()

    ; Array of excluded applications.
    excludedApps := ["Explorer.EXE", "Spotify.exe", "WindowsTerminal.exe", "wmplayer.exe", "vlc.exe"]

    ; If winExe has no value, most likely, Windows is locked.
    if (winExe != "")
    {
        if (IsInVar(excludedApps, winExe) == 0)
        {
            Send "^{z}^{y}"
            ; OutputDebug "Simulated Key: Ctrl+x, Ctrl+y"
        }
        else
        {
            Send "{Left}{Right}"
            ; OutputDebug "Simulated Key: Left, Right"
        }

        ; Send "{Shift 2}""
        ; OutputDebug "Simulated Key: Shift x 2"

        ; Specific key presses based on specific applications.

        ; if (winExe == "msedge.exe")
        ; {
        ;     Send "{Up}""
        ;     Send "{Down}""
        ; }
        ; else if (winExe == "chrome.exe")
        ; {
        ;     Send "{Shift 2}""
        ; }
        ; else if (winExe != "firefox.exe"))
        ; {
        ;     Send "{Alt 2}""
        ; }
    }
}

; Checks if [needle] is in the [haystack]. Returns the index location when found.
; Otherwise, returns 0.
IsInVar(haystack, needle)
{
    for index, value in haystack
        if (value = needle)
            return index

    if !(IsObject(haystack))
        throw Exception("Bad haystack!", -1, haystack)

    return 0
}

; Checks if the user is currently typing something.
UserIsTyping()
{
    ; Waits for the user to press any key (L1 = 1 character).
    ; Waits for just 1 second (T1 = 1 second).
    ; Ensures that the user's keystrokes are sent to the active window (V).
    ; Keys that produce no visible character such as the modifier keys,
    ;   function keys, and arrow keys are listed as End Keys so that they will
    ;   be detected, too.
    pressedKey := InputHook("L1 T1 V", "{LControl}{RControl}{LAlt}{RAlt}{LShift}{RShift}{LWin}{RWin}{AppsKey}{F1}{F2}{F3}{F4}{F5}{F6}{F7}{F8}{F9}{F10}{F11}{F12}{Left}{Right}{Up}{Down}{Home}{End}{PgUp}{PgDn}{Del}{Ins}{BS}{CapsLock}{NumLock}{PrintScreen}{Pause}")
    pressedKey.Start()
    endReason := pressedKey.Wait()

    if (endReason = "Timeout")
    {
        ; OutputDebug "Pressed Key: Timed out"
        return false
    }

    ; OutputDebug "The user is typing."
    ; OutputDebug "Pressed Key: " . pressedKey.EndKey

    return true
}
