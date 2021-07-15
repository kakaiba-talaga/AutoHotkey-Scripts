; This can launch Chrome instances based on the profile.
; If the Chrome profile was already launched, it will activate or set the focus to that window.

; Author: kakaiba-talaga
; License: GPL-3.0-or-later
; Repository: https://github.com/kakaiba-talaga/AutoHotkey-Scripts

DetectHiddenWindows, On

chrome_profile_launcher(profile := "Default")
{
    ; Set to static to be able to remember the values between calls.
    static chromeProfiles := {}
    
    ; Remove any spaces at the beginning and end of the string.
    profile := Trim(profile)
    
    ; Message Box title.
    msgTitle := "Chrome Profile Launcher | kakaiba-talaga"
    
    if (profile != "")
    {
        chromeExe := "chrome.exe"
        targetProfile := chromeExe . " --profile-directory=""" . profile . """"
        
        profileHwnd := chromeProfiles[profile]
        
        ; Check if the Chrome profile is already set and the Chrome window exists.
        if (profileHwnd and WinExist("ahk_id " . profileHwnd))
        {
            ; Activate the window.
            WinActivate, ahk_id %profileHwnd%
        }
        else
        {
            ; Open Chrome using the specified profile.
            Run %targetProfile%
            
            ; Wait for the Chrome window to be active.
            WinWaitActive, ahk_exe chrome.exe, , 5

            if (ErrorLevel)
                MsgBox, 0, %msgTitle%, The Chrome window does not exist or is not activated, yet.
            else
            {
                ; Get the unique ID number of the Chrome window.
                WinGet, chromeHwnd, ID, A
                
                ; Store the ID to be able to track it.
                chromeProfiles[profile] := chromeHwnd
            }
        }
    }
    else
    {
        MsgBox, 0, %msgTitle%, The "profile" parameter is required.
    }
}