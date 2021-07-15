; This AHK script was originally created by Andreas Borutta.
; This was modified to be able to create new Hotstrings without reloading.
; This was modified again with some optimizations by kakaiba-talaga.

; Author: kakaiba-talaga
; License: GPL-3.0-or-later
; Repository: https://github.com/kakaiba-talaga/AutoHotkey-Scripts

; Skips the dialog box and replaces the old instance automatically.
#SingleInstance Force


; CTRL + ALT + H Hotkey
^!h::
; Get the text currently selected. The clipboard is used instead of "ControlGet Selected" because it works in a greater variety of editors (namely word processors).
; Save the current clipboard contents to be restored later.
; Although this handles only plain text, it seems better than nothing.
ClipboardOld := Clipboard
Clipboard := ""  ; Must start off blank for detection to work.
Send ^c
ClipWait 1

; ClipWait timed out.
if ErrorLevel
    return

; Replace CRLF and/or LF with `n for use in a "send-raw" Hotstring.
; The same is done for any other characters that might otherwise be a problem in raw mode.
ClipContent := StrReplace(Clipboard, "``", "````")  ; Do this replacement first to avoid interfering with the others below.
ClipContent := StrReplace(ClipContent, "`r`n", "``r")  ; Using `r works better than `n in MS Word, etc.
ClipContent := StrReplace(ClipContent, "`n", "``r")
ClipContent := StrReplace(ClipContent, "`t", "``t")
ClipContent := StrReplace(ClipContent, "`;", "```;")

; Restore previous contents of clipboard.
Clipboard := ClipboardOld

ShowInputBox(":T:`::" ClipContent)

return


ShowInputBox(defaultValue)
{
    msgTitle := "New Hotstring | Optimized by kakaiba-talaga"

    ; Causes a subroutine labelled MoveCaret to be launched automatically and repeatedly at a specified time interval.
    SetTimer, MoveCaret, 10

    ; Show the input box, providing the default Hotstring.
    InputBox, UserInput, %msgTitle%,
    (
    Type your abreviation at the indicated insertion point. You can also edit the replacement text if you like.

    Example entry:
        :R:btw`::by the way
    ),,,,,,,, %defaultValue%

    ; The user pressed Cancel.
    if ErrorLevel
        return

    if RegExMatch(UserInput, "O)(?P<Label>:.*?:(?P<Abbreviation>.*?))::(?P<Replacement>.*)", Hotstring)
    {
        if !Hotstring.Abbreviation or Trim(Hotstring.Abbreviation) = ""
            msgText := "You didn't provide an abbreviation."
        else if !Hotstring.Replacement or Trim(Hotstring.Replacement) = ""
            msgText := "You didn't provide a replacement."
        else
        {
            ; Enable the Hotstring now.
            Hotstring(Hotstring.Label, Hotstring.Replacement)

            ; Save the Hotstring for later use.
            FileAppend, `n%UserInput%, %A_ScriptFullPath%
        }
    }
    else
        msgText := "The Hotstring appears to be improperly formatted."

    if msgText
    {
        MsgBox, 4, %msgTitle%, %msgText% Would you like to try again?
        IfMsgBox, Yes
            ShowInputBox(defaultValue)
    }

    return


    ; This will move the input box's caret to a more friendly position.
    MoveCaret:
    WinWait, %msgTitle%

    ; Move the input box's insertion point to where the user will type the abbreviation.
    Send {Home}{Right 3}

    ; Disable the existing timer.
    SetTimer,, Off
    
    return
}

; User created Hotstrings through this script.