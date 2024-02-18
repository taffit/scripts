#Requires AutoHotkey v2.0
; The following found here: http://lifehacker.com/5277383/use-caps-lock-for-hand+friendly-text-navigation
; Modified for being more VIM friendly.

SendMode("Input")  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir(A_ScriptDir)  ; Ensures a consistent starting directory.
;#NoTrayIcon

SetCapsLockState("AlwaysOff")
; Remapping Capslock to ESC. Use AltGr+Capslock to activate Capslock
<^>!CapsLock::CapsLock
CapsLock::Escape
CapsLock & k::
{
  if getkeystate("shift") = 0
      Send("{Up}")
  else
      Send("+{Up}")
  return
}

CapsLock & l::
{
  if getkeystate("shift") = 0
      Send("{Right}")
  else
      Send("+{Right}")
  return
}

CapsLock & h::
{
  if getkeystate("shift") = 0
      Send("{Left}")
  else
      Send("+{Left}")
  return
}

CapsLock & j::
{
  if getkeystate("shift") = 0
      Send("{Down}")
  else
      Send("+{Down}")
  return
}

;CapsLock & ,::
;{
;  if getkeystate("alt") = 0
;    Send,^{Down}
;  else
;    Send,+^{Down}
;  return
;}
;CapsLock & 8::
;{
;  if getkeystate("alt") = 0
;    Send,^{Up}
;  else
;    Send,+^{Up}
;  return
;}

CapsLock & y::
{
  if getkeystate("shift") = 0
      Send("{Home}")
  else
      Send("+{Home}")
  return
}

CapsLock & u::
{
  if getkeystate("shift") = 0
      Send("^{Left}")
  else
      Send("+^{Left}")
  return
}

CapsLock & i::
{
  if getkeystate("shift") = 0
      Send("^{Right}")
  else
      Send("+^{Right}")
  return
}

CapsLock & o::
{
  if getkeystate("shift") = 0
      Send("{End}")
  else
      Send("+{End}")
  return
}

CapsLock & CtrlBreak::Send("{Media_Play_Pause}")
CapsLock & ScrollLock::Send("{Media_Stop}")
CapsLock & PrintScreen::Send("{Volume_Mute}")
CapsLock & -::Send("{Volume_Down 1}")
CapsLock & =::Send("{Volume_Up 1}")
CapsLock & [::Send("{Media_Prev}")
CapsLock & ]::Send("{Media_Next}")
CapsLock & Tab::Send("^!{Tab}")

;LCtrl & ,::ShiftAltTab
;LCtrl & .::AltTab

RAlt & a::
{
  state := GetKeyState("Shift", ) ? "D" : "U"
  if (state = "D")
     SendInput("{ASC 142}")
  Else
     Send("{ASC 132}")
  return
}
RAlt & o::
{
  state := GetKeyState("Shift", ) ? "D" : "U"
  if (state = "D")
     SendInput("{ASC 153}")
  else
     Send("{ASC 148}")
  return
}
RAlt & u::
{
  state := GetKeyState("Shift", ) ? "D" : "U"
  if (state = "D")
     SendInput("{ASC 154}")
  else
     Send("{ASC 129}")
  return
}

;CapsLock & a::Send, {ASC 142}
;CapsLock & o::Send, {ASC 153}
;CapsLock & u::Send, {ASC 154}

; For using e.g. CapsLock + Alt + k
;Capslock & k::
;GetKeyState, state, Alt
;if state = D
;SendInput !{Up}
;Return

CapsLock & BS::Send("{Del}")
CapsLock & a::Send("^a")
CapsLock & x::Send("^x")
CapsLock & c::Send("^c")
CapsLock & v::Send("^v")
CapsLock & w::Send("^w")
; Useful for refreshing or executing script in MS SQL Manager
CapsLock & r::Send("{F5}")

; Prevents CapsState-Shifting
CapsLock & Space::Send("{Space}")

; The &middot; or Â· or U+00B7, using AltGr+.
<^>!.::Send("{U+00B7}")
; ... or redefined CapsLock with the dot
CapsLock & .::Send("{U+00B7}")

; Mapping the dot on the NumPad to a German ,
NumpadDot::Send("{,}")

; Pin / unpin a window to be always on top
^+Space::WinSetAlwaysOnTop(, "A")

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
#HotIf WinActive("ahk_class ConsoleWindowClass")
^v::
{
  SendInput("{Raw}" A_Clipboard)
  return
}
#HotIf

; Hold ALT down on clicking, simulates a double left click
!LButton::Send("{Click 2}")

; Windows + V to paste plain text.
#v::
{
  ClipSaved := ClipboardAll()
  A_Clipboard := A_Clipboard
  SendInput("^v")
  Sleep(250)
  A_Clipboard := ClipSaved
  return
}

; Windows + H to copy the colour of the pixel under the cursor to the clipboard
; Source: https://twitter.com/nickjanetakis/status/1108825825116332032
#h::
{
  MouseGetPos(&MouseX, &MouseY)
  color := PixelGetColor(MouseX, MouseY, ) ;V1toV2: Switched from BGR to RGB values
  color := StrLower(color)
  A_Clipboard := SubStr(color, 3)
  return
}

; Windows + U to enter a Unicode-character
; See: https://superuser.com/a/1047221/299215
SendUnicode()
{
  ihhex := InputHook("l4")
  ihhex.Start()
  ihhex.Wait()
  hex := ihhex.Input
  Send("{U+" hex "}")
  return
}
#u::SendUnicode()

; Semicolon + u followed by an ending character and a code and finished with semicolon will output the unicode
; character, considering also unicode characters in the upper-area, i. e. the ones needing surrogate pairs.
; See: https://stackoverflow.com/questions/36563635/autohotkey-send-5-digit-hex-unicode-chars
:?:`;u::
{
  ihkeys := InputHook("V","{Enter}{CapsLock}{Escape}`;")
  ihkeys.Start()
  ihkeys.Wait()
  keys := ihkeys.Input  ; Enter the code, finish with ; or interrupt with Esc/Enter
  len := StrLen(keys)  ; The length of the inserted code
  endkey := (ihkeys.EndKey = ";") or (ihkeys.EndKey = "Enter") ? 1 : 0  ; Should we remove also the endKey
  Send("{BS " . len + endKey . "}")  ; Now remove the entered code, including the endKey, if provided
  if endKey = 1
  {
    if len < 5
      SendInput("{U+" . keys . "}")
    else {
      ; Generate the surrogate pairs
      keys := "0x" . keys
      num := keys - 0x10000
      w1 := Format("{:x}", (num >> 10) . 0xD800)
      w2 := Format("{:x}", (num & 1023) . 0xDC00)
      Send("{U+" . w1 . "}{U+" . w2 . "}")
    }
  }
  return
}

; Win+Shift+S has been taken by Windows very own Snip & Catch
; Windows + Shift + S to change sound output. Useful when you want to change from headphones to speakers.
; #+s::
    ; toggle:=!toggle ; toggles up and down states
    ; Run, mmsys.cpl
    ; WinWait,Sound ;Change "Sound" to the name of the window in your local language
    ; if toggle
        ; ControlSend,SysListView321,{Down 1} ; This number selects the matching audio device in the list, change it accordingly
    ; Else
        ; ControlSend,SysListView321,{Down 1} ; This number selects the matching audio device in the list, change it accordingly
    ; ControlClick,&Set Als Standard ;Default ; Change "&Set Default" to the name of the button in your local language
    ; ControlClick,OK
; return

; Windows + Shift + G to insert an uppercase GUID
#+g::
{
  TypeLib := ComObject("Scriptlet.TypeLib")
  NewGUID := TypeLib.Guid
  NewGUID := StrUpper(NewGUID)
  SendInput("{Raw}" NewGUID)
  return
}

; Ctrl or ESC 3x to center mouse pointer, see https://www.autohotkey.com/docs/v2/lib/SetTimer.htm#ExampleCount
~LCtrl::
~Escape::
CenterMouseCursor(hk)
{
  static hotkey_presses := 0
  if hotkey_presses > 0 ; SetTimer already started, so we log the keypress instead.
  {
    if (A_ThisHotkey = A_PriorHotkey && A_TimeSincePriorHotkey > 50 && A_TimeSincePriorHotkey < 500)
    {
      hotkey_presses += 1
      return
    }
  }
  ; Otherwise, this is the first press of a new series. Set count to 1 and start the timer:
  hotkey_presses := 1
  SetTimer(HotKeyPressed,-750) ; Wait for more presses within a 750 millisecond window.

  HotKeyPressed()  ; This is a nested function.
  {
    if (hotkey_presses = 3)
    {
      CoordMode("Mouse", "Screen")
      MouseMove((A_ScreenWidth // 2), (A_ScreenHeight // 2))
    }
    ; Regardless of which action above was triggered, reset the count to
    ; prepare for the next series of presses:
    hotkey_presses := 0
  }
}


#Include local.ahk