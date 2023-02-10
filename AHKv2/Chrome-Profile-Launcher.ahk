; This can launch Chrome instances based on the profile.
; If the Chrome profile was already launched, it will activate or set the focus to that window.

; Author: kakaiba-talaga
; License: GPL-3.0-or-later
; Repository: https://github.com/kakaiba-talaga/AutoHotkey-Scripts

#Requires AutoHotkey >=2.0

DetectHiddenWindows true


chrome_profile_launcher(profile := "Default")
{
    ; Set to static to be able to remember the values between calls.
    static chromeProfiles := Map()

    ; Remove any spaces at the beginning and end of the string.
    profile := Trim(profile)

    ; Message Box title.
    msgTitle := "Chrome Profile Launcher | kakaiba-talaga"

    if (profile != "")
    {
        chromeExe := "chrome.exe"
        targetProfile := chromeExe . ' --profile-directory="' . profile . '"'

        if (chromeProfiles.Has(profile))
        {
            profileHwnd := chromeProfiles[profile]
        }
        else
        {
            profileHwnd := 0
        }

        ; Check if the Chrome profile is already set and the Chrome window exists.
        if (profileHwnd != 0 and WinExist("ahk_id " . profileHwnd))
        {
            ; Activate the window.
            WinActivate "ahk_id " . profileHwnd
        }
        else
        {
            ; Open Chrome using the specified profile.
            Run targetProfile

            ; Wait for the Chrome window to be active.
            profileHwnd := WinWaitActive("ahk_exe chrome.exe", , 5)

            if (profileHwnd == 0 or profileHwnd == 1)
            {
                MsgBox "The Chrome window does not exist or is not activated, yet.", msgTitle, 0
            }
            else
            {
                ; Get the unique ID number of the Chrome window.
                profileHwnd := WinGetID("ahk_exe chrome.exe")

                ; Store the ID to be able to track it.
                chromeProfiles[profile] := profileHwnd
            }
        }
    }
    else
    {
        MsgBox "The 'profile' parameter is required.", msgTitle, 0
    }
}
