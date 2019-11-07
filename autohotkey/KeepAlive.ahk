#SingleInstance force
#Persistent
/*
   The following script is a mixture of snippets found all over the web. It
   includes the main part found on https://forum.devolutions.net/topic1151-rdp-keep-alive.aspx#post111394
   (which does a good job on simulating activity when there isn't). This is enriched
   with additional mouse movements and randomized a bit.
*/
CoordMode, Mouse, Screen
; Deactivate mouse movements by default
move := 0

; Number of pixels to move
pxmov := 5
; Randomize the movement, between 5 and 25 seconds
Random, tick, 5000, 25000
SetTimer, NoSleep, %tick%
; Return
; Win-F8 will toggle the mouse movements
#F8:: move := !move

NoSleep:
  if move {
      ; On multiple monitors the following method seems to be more stable
      MouseGetPos, xpos, ypos
      xpos := xpos + pxmov
      DllCall("SetCursorPos", "int", xpos, "int", ypos)  ; The first number is the X-coordinate and the second is the Y (relative to the screen).
      ; Afterwards it should move back the same amount
      pxmov := -1 * pxmov
  }
  ; Now do the Windows call which seems to do a good job
  DllCall( "SetThreadExecutionState", UInt,0x80000003 )
Return