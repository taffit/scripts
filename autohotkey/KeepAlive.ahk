#Requires AutoHotkey v2.0
#SingleInstance force
Persistent
/*
   The following script is a mixture of snippets found all over the web. It
   includes the main part found on https://forum.devolutions.net/topic1151-rdp-keep-alive.aspx#post111394
   (which does a good job on simulating activity when there isn't). This is enriched
   with additional mouse movements and randomized a bit.
*/
CoordMode("Mouse", "Screen")
; Activate mouse movements by default (as that's what one would expect)
move := 1

; Start in 5 seconds
tick := 5000
SetTimer(NoSleep,tick)

; Win-F8 will toggle the mouse movements
#F8:: move := !move
Return

NoSleep()
{
  if move {
      ; Randomize the number of pixels to move
      pxmov := Random(-1 * Min(A_ScreenWidth, A_ScreenHeight)/2, Min(A_ScreenWidth, A_ScreenHeight)/2)
      ; Randomize which direction to move (0..stay, 1..to y, 2..to x, 3..add pxmov to both)
      direction := Random(-3, 3)
      direction := Abs(direction)
      ; On multiple monitors the following method seems to be more stable
      MouseGetPos(&xpos, &ypos)
      Switch direction
      {
      Case 1:
        xpos := xpos + pxmov
      Case 2:
        ypos := ypos + pxmov
      Case 3:
        xpos := xpos + pxmov
        ypos := ypos + pxmov
      ;Default:
      }
      MouseMove(xpos, ypos, 50)
      DllCall("SetCursorPos", "int", xpos, "int", ypos)  ; The first number is the X-coordinate and the second is the Y (relative to the screen).
      ; Afterwards it should move back the same amount
      ;pxmov := -1 * pxmov
  }
  ; Now do the Windows call which seems to do a good job
  DllCall("SetThreadExecutionState", "UInt", 0x80000003)
  
  ; Randomize the movement, between 5 and 25 seconds
  tick := Random(5000, 25000)
  SetTimer(NoSleep, tick)
  return
}

