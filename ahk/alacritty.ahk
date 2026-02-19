#Requires AutoHotkey v2.0

#Enter::Run("alacritty.exe")
#+b::Run("brave.exe --new-window http://www.google.com/")
^#+b::Run("brave.exe --new-window --incognito http://www.google.com/")
+!s::{
    path := FileRead("C:\Users\daniel.knezevic\.latest-screenshot")
    SendText(RTrim(path, "`r`n"))
}

; Fn+CapsLock to toggle actual CapsLock state
F24 & CapsLock::SetCapsLockState(!GetKeyState("CapsLock", "T"))

; Global flag to track if CapsLock was used as a modifier
global capsUsedAsModifier := false
global capsLockPressTime := 0

*CapsLock::
{
    global capsUsedAsModifier, capsLockPressTime
    capsUsedAsModifier := false
    capsLockPressTime := A_TickCount
    
    ; Always turn off CapsLock if it's active
    if (GetKeyState("CapsLock", "T"))
    {
        SetCapsLockState(false)
    }
    
    ; Send Ctrl down immediately
    Send "{Ctrl down}"
    
    ; Wait for CapsLock to be released
    KeyWait "CapsLock"
    
    ; Release Ctrl
    Send "{Ctrl up}"
    
    ; Calculate how long the key was held
    elapsedTime := A_TickCount - capsLockPressTime
    
    ; Only send Escape if it was a quick tap (< 500ms) and not used as modifier
    if (!capsUsedAsModifier && elapsedTime < 500)
    {
        Send "{Esc}"
    }
}

; Catch any key press while CapsLock is held
#HotIf GetKeyState("CapsLock", "P")
~*a:: global capsUsedAsModifier := true
~*b:: global capsUsedAsModifier := true
~*c:: global capsUsedAsModifier := true
~*d:: global capsUsedAsModifier := true
~*e:: global capsUsedAsModifier := true
~*f:: global capsUsedAsModifier := true
~*g:: global capsUsedAsModifier := true
~*h:: global capsUsedAsModifier := true
~*i:: global capsUsedAsModifier := true
~*j:: global capsUsedAsModifier := true
~*k:: global capsUsedAsModifier := true
~*l:: global capsUsedAsModifier := true
~*m:: global capsUsedAsModifier := true
~*n:: global capsUsedAsModifier := true
~*o:: global capsUsedAsModifier := true
~*p:: global capsUsedAsModifier := true
~*q:: global capsUsedAsModifier := true
~*r:: global capsUsedAsModifier := true
~*s:: global capsUsedAsModifier := true
~*t:: global capsUsedAsModifier := true
~*u:: global capsUsedAsModifier := true
~*v:: global capsUsedAsModifier := true
~*w:: global capsUsedAsModifier := true
~*x:: global capsUsedAsModifier := true
~*y:: global capsUsedAsModifier := true
~*z:: global capsUsedAsModifier := true
~*0:: global capsUsedAsModifier := true
~*1:: global capsUsedAsModifier := true
~*2:: global capsUsedAsModifier := true
~*3:: global capsUsedAsModifier := true
~*4:: global capsUsedAsModifier := true
~*5:: global capsUsedAsModifier := true
~*6:: global capsUsedAsModifier := true
~*7:: global capsUsedAsModifier := true
~*8:: global capsUsedAsModifier := true
~*9:: global capsUsedAsModifier := true
~*Space:: global capsUsedAsModifier := true
~*Enter:: global capsUsedAsModifier := true
~*Tab:: global capsUsedAsModifier := true
~*Backspace:: global capsUsedAsModifier := true
~*Delete:: global capsUsedAsModifier := true
~*Home:: global capsUsedAsModifier := true
~*End:: global capsUsedAsModifier := true
~*PgUp:: global capsUsedAsModifier := true
~*PgDn:: global capsUsedAsModifier := true
~*Up:: global capsUsedAsModifier := true
~*Down:: global capsUsedAsModifier := true
~*Left:: global capsUsedAsModifier := true
~*Right:: global capsUsedAsModifier := true
~*F1:: global capsUsedAsModifier := true
~*F2:: global capsUsedAsModifier := true
~*F3:: global capsUsedAsModifier := true
~*F4:: global capsUsedAsModifier := true
~*F5:: global capsUsedAsModifier := true
~*F6:: global capsUsedAsModifier := true
~*F7:: global capsUsedAsModifier := true
~*F8:: global capsUsedAsModifier := true
~*F9:: global capsUsedAsModifier := true
~*F10:: global capsUsedAsModifier := true
~*F11:: global capsUsedAsModifier := true
~*F12:: global capsUsedAsModifier := true
~*Esc:: global capsUsedAsModifier := true
~*`;:: global capsUsedAsModifier := true
~*':: global capsUsedAsModifier := true
~*,:: global capsUsedAsModifier := true
~*.:: global capsUsedAsModifier := true
~*/:: global capsUsedAsModifier := true
~*[:: global capsUsedAsModifier := true
~*]:: global capsUsedAsModifier := true
~*\:: global capsUsedAsModifier := true
~*-:: global capsUsedAsModifier := true
~*=:: global capsUsedAsModifier := true
~*`:: global capsUsedAsModifier := true
#HotIf
