# AutoHotkey Scripts

This is a compilation of reusable `AHK` scripts.

- [AutoHotkey Scripts](#autohotkey-scripts)
    - [Requirements](#requirements)
    - [AHK Scripts](#ahk-scripts)
        - [Maximum Performance](#maximum-performance)
    - [Contribute](#contribute)
    - [License](#license)

## Requirements

[AutoHotkey](https://www.autohotkey.com/) should be installed first or use a compiled version of the `AHK` script so it can run by its own.

- AutoHotkey is only available for **Windows**.
- Developed and Tested using version `>= 1.1.33.09`, `< 2.0`.
- All scripts that have a `v2` counterpart will only work in `>= 2.0`.

[Go back to TOC](#autohotkey-scripts)

## AHK Scripts

- [Chrome Profile Launcher](AHK/Chrome-Profile-Launcher.ahk), [Chrome Profile Launcher v2](AHKv2/Chrome-Profile-Launcher.ahk)

    This can launch Chrome instances based on the profile. If the Chrome profile was already launched by this script, it will activate or set the focus to that window.

    ```ahk
    ; CTRL + ALT + ` >>> Open Chrome using the Default profile.
    ^!`::
        chrome_profile_launcher()
        return
    ```

    ```ahk
    ; CTRL + ALT + 1 >>> Open Chrome using the Profile 1 profile.
    ^!1::
        chrome_profile_launcher("Profile 1")
        return
    ```

    Take note that the `DetectHiddenWindows` is turned `On` so the script can detect the Chrome windows across different virtual desktops.

- [Hotstring Helper](AHK/Hotstring-Helper.ahk)

    This script may be useful if you are a heavy user of _Hotstrings_. It's based on the script originally created by _Andreas Borutta_.

    By pressing the specified _Hotkey_, `CTRL + ALT + H` in this case, the currently selected text can be turned into a _Hotstring_. The newly created _Hotstring_ will be appended in the script itself.

    This was customized to be able to add the new _Hotstring_ and activate it without reloading the script. In my version, I just made some optimizations.

    This will run at high priority at [maximum performance](#maximum-performance).

- [MoveMouse](AHK/MoveMouse.ahk), [MoveMouse v2](AHKv2/MoveMouse.ahk)

    Prevents the computer from _sleeping_ or _idling_ by moving the mouse cursor to different positions at different speeds at different intervals.

    Some rules:

    1. If Windows is locked, the mouse cursor will not be moved.
    2. If the user is typing, the mouse cursor will not be moved.
    3. If the mouse cursor position is not the same as the initial position, the mouse cursor will not be moved.
    4. After some time, this will simulate key presses to prevent idling on some timers. If the user is typing, the script will not simulate any key presses.
    5. There are some exceptions, when certain executables are in focus, where the key presses are not simulated.

    This will run at high priority at [maximum performance](#maximum-performance).

    This was inspired by the `NoSleep` _(.Net)_ app by _Mike Langford_.

### Maximum Performance

Some of the scripts were optimized to be able to run at maximum performance. This was achieved by adding the following lines of codes at the beginning:

```autohotkey
#NoEnv ; Prevents empty variables from being looked up as potential environment variables
SetBatchLines -1 ; Run the script at maximum speed.
ListLines Off ; Omits subsequently-executed lines from the history.
```

As of `AutoHotkey v2`, this is **not** needed anymore.

[Go back to TOC](#autohotkey-scripts)

## Contribute

Community contributions are encouraged! Feel free to report bugs and feature requests to the [issue tracker](https://github.com/kakaiba-talaga/AutoHotkey-Scripts/issues) provided by _GitHub_.

## License

`AutoHotkey Scripts` is an Open-Source Software _(OSS)_ and is available for use under the [GNU GPL v3](https://github.com/kakaiba-talaga/AutoHotkey-Scripts/blob/main/LICENSE) license.

[Go back to TOC](#autohotkey-scripts)
