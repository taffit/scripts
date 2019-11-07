; The following found here: http://lifehacker.com/5277383/use-caps-lock-for-hand+friendly-text-navigation
; Modified for being more VIM friendly.

;
; Script Function:
;	Template script (you can customize this template by editing "ShellNew\Template.ahk" in your Windows folder)
;

#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
;#NoTrayIcon

SetCapsLockState, AlwaysOff
CapsLock::Send {Esc}
CapsLock & k::
    if getkeystate("shift") = 0
        Send,{Up}
    else
        Send,+{Up}
return

CapsLock & l::
    if getkeystate("shift") = 0
        Send,{Right}
    else
        Send,+{Right}
return

CapsLock & h::
    if getkeystate("shift") = 0
        Send,{Left}
    else
        Send,+{Left}
return

CapsLock & j::
    if getkeystate("shift") = 0
        Send,{Down}
    else
        Send,+{Down}
return

;CapsLock & ,::
;    if getkeystate("alt") = 0
;        Send,^{Down}
;    else
;        Send,+^{Down}
;return
;
;CapsLock & 8::
;    if getkeystate("alt") = 0
;        Send,^{Up}
;    else
;        Send,+^{Up}
;return

CapsLock & y::
    if getkeystate("shift") = 0
        Send,{Home}
    else
        Send,+{Home}
return

CapsLock & u::
    if getkeystate("shift") = 0
        Send,^{Left}
    else
        Send,+^{Left}
return

CapsLock & i::
    if getkeystate("shift") = 0
        Send,^{Right}
    else
        Send,+^{Right}
return

CapsLock & o::
    if getkeystate("shift") = 0
        Send,{End}
    else
        Send,+{End}
return

CapsLock & Break::
    Send,{Media_Play_Pause}
return

CapsLock & ScrollLock::
    Send,{Media_Stop}
return

CapsLock & PrintScreen::
    Send,{Volume_Mute}
return

CapsLock & -::
    Send {Volume_Down 1}
return

CapsLock & =::
    Send {Volume_Up 1}
return

CapsLock & [::
    Send {Media_Prev}
return

CapsLock & ]::
    Send {Media_Next}
return

CapsLock & Tab::
    Send, ^!{Tab}
return

;LCtrl & ,::ShiftAltTab
;LCtrl & .::AltTab

RAlt & a::
    GetKeyState, state, Shift
    if state = D
       SendInput {ASC 142}
    Else
       Send,{ASC 132}
Return
RAlt & o::
    GetKeyState, state, Shift
    if state = D
       SendInput {ASC 153}
    Else
       Send,{ASC 148}
Return
RAlt & u::
    GetKeyState, state, Shift
    if state = D
       SendInput {ASC 154}
    Else
       Send,{ASC 129}
Return

;CapsLock & a::Send, {ASC 142}
;CapsLock & o::Send, {ASC 153}
;CapsLock & u::Send, {ASC 154}

; For using e.g. CapsLock + Alt + k
;Capslock & k::
;GetKeyState, state, Alt
;if state = D
;SendInput !{Up}
;Return

CapsLock & BS::Send,{Del}
CapsLock & a::Send ^a
CapsLock & x::Send ^x
CapsLock & c::Send ^c
CapsLock & v::Send ^v
CapsLock & w::Send ^w
;Useful for refreshing or executing script in MS SQL Manager
CapsLock & r::Send {F5}

;Prevents CapsState-Shifting
CapsLock & Space::Send,{Space}

;*Capslock::SetCapsLockState, AlwaysOff
;Remapping Capslock to ESC. Use AltGr+Capslock to activate Capslock
<^>!CapsLock::CapsLock

;Mapping the dot on the NumPad to a German ,
NumpadDot::Send {,}

;Pin / unpin a window to be always on top
^+Space:: Winset, AlwaysOnTop, , A

; Left mouse + right mouse = volume up, right mouse + left mouse = volume down
;~LButton & RButton::
;{
    ;Loop
    ;{
        ;GetKeyState, state, LButton
        ;if state = U
        ;{
            ;break
        ;}
        ;Sleep, 500
        ;Send {Volume_Up 1}
    ;}
;
    ;Return
;}

;~RButton & LButton::
;{
    ;Loop
    ;{
        ;GetKeyState, state, RButton
        ;if state = U
        ;{
            ;break
        ;}
        ;Sleep, 500
        ;Send {Volume_Down 1}
    ;}
;
    ;Return
;}

; Paste in command prompt
; ; AutoHotkey Version: 1.x ; Language: English ; Author: Lowell Heddings | geek@howtogeek.com
; ; Script Function: ; enable paste in the Windows command prompt ; #NoTrayIcon
#IfWinActive ahk_class ConsoleWindowClass ^v::
    SendInput {Raw}%clipboard%
    return
#IfWinActive

;Hold ALT down on clicking, simulates a double left click
!LButton::Send {Click 2}

;Windows + V to paste plain text.
#v::
    ClipSaved := ClipboardAll
    Clipboard = %Clipboard%
    SendInput, ^v
    Sleep, 250
    Clipboard := ClipSaved
return

;Windows + H to copy the colour of the pixel under the cursor to the clipboard
;Source: https://twitter.com/nickjanetakis/status/1108825825116332032
#h::
    MouseGetPos, MouseX, MouseY
    PixelGetColor, color, %MouseX%, %MouseY%
    StringLower, color, color
    Clipboard := SubStr(color, 3)
return


;Windows + Shift + S to change sound output. Useful when you want to change from headphones to speakers.
#+s::
    toggle:=!toggle ; toggles up and down states
    Run, mmsys.cpl
    WinWait,Sound ;Change "Sound" to the name of the window in your local language
    if toggle
        ControlSend,SysListView321,{Down 1} ; This number selects the matching audio device in the list, change it accordingly
    Else
        ControlSend,SysListView321,{Down 1} ; This number selects the matching audio device in the list, change it accordingly
    ControlClick,&Set Als Standard ;Default ; Change "&Set Default" to the name of the button in your local language
    ControlClick,OK
return

;Windows + Shift + G to insert an uppercase GUID
#+g::
    TypeLib := ComObjCreate("Scriptlet.TypeLib")
    NewGUID := TypeLib.Guid
    StringUpper NewGUID, NewGUID
    SendInput, {Raw}%NewGUID%
return
