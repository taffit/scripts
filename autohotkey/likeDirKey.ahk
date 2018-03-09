; ---------------------------------------------------------------------
; Name:             likeDirkey v0.1
; Author:           Wolfgang Reszel für c't
; Datum:            6.12.2004
;
; Language:         german/english
; Platform:         tested with XP
; #Includeable:     yes
;
; Beschreibung:                                                (german)
; ---------------------------------------------------------------------
; Dieses Skript simuliert in etwas die Funktionalität von Dirkey.
; Es werden dabei nur die Tastaturkürzel Strg+1 - Strg+0 nachgeahmt
; Dieses Skript eignet sich gut zum Includieren in vorhandene Skripte.
; Zudem gibt es noch die Kürzel Win+1 - Win+0, welche im die
; Verzeichnisse immer in einem neuen Explorer-Fenster öffnen.
; ---------------------------------------------------------------------
; Adjusted by Rohwedder, found here: https://autohotkey.com/board/topic/124088-likedirkey-v01/
; ---------------------------------------------------------------------
; -- Konfiguration: ---------------------------------------------------
; ---------------------------------------------------------------------
 
; Welche Laufwerke sollen berücksichtigt werden?
Folder_ld1 = C:\~am
Folder_ld2 = C:\~ws
Folder_ld3 = %DESKTOP%
Folder_ld4 = C:\~ws\api
Folder_ld5 = C:\~tmp
Folder_ld6 = C:\~ws\github
Folder_ld7 = C:\~
Folder_ld8 = C:\~ds
Folder_ld9 = %USERPROFILE%
Folder_ld0 = %A_Scriptdir%
 
; ---------------------------------------------------------------------
; -- Initialisierung --------------------------------------------------
; ---------------------------------------------------------------------
 
; Alle 10 Strings aus Pseudo-Array mit Kürzeln belegen
Loop, 10
{
   Index_ld = %A_Index%
   Index_ld -= 1
   StringTrimLeft, current_ld, Folder_ld%Index_ld%,0 ; Pfad auslesen
   If current_ld ; Wenn nicht leer
   {
      Hotkey, ~^%Index_ld%, DirKey_ld ; Strg+ Kürzel zuweisen
      Hotkey, +#%Index_ld% , DirKey_ld ; Shift+Win+ Kürzel zuweisen
   }
}
 
Return ; Auto-Execute-Bereich ist hier zu Ende
 
; Unterroutine für Tastaturkürzel
DirKey_ld:
   StringRight, Index_ld, A_thishotkey, 1 ; Nur die Zahl des Kürzels
   StringTrimLeft, d_path, Folder_ld%Index_ld%,0 ; Pfad auslesen
   gosub, d_ChangeDir ; Verzeichniswechsel aufrufen
return
 
; ---------------------------------------------------------------------
; -- Unterroutine für den Verzeichniswechsel --------------------------
; ---------------------------------------------------------------------
d_ChangeDir: ; Unterroutine für den Verzeichniswechsel
 
   WinGet     , d_window_id, ID, A             ; ID es aktiven Fensters
   WinGetClass, d_class, ahk_id %d_window_id%  ; Fensterklasse ermitteln
 
   ; Prüfen ob Fensterklasse unterstützt wird
   if d_class contains #32770,ExploreWClass,CabinetWClass,Afx:400000:0,FileZilla Main Window,bosa_sdm
   {
      ; Ermitteln ob ein Edit1-Control vorhanden ist (Eingabezeile)
      d_EditClass = Edit1
      ControlGetPos, d_Edit1Pos,,,, %d_EditClass% , ahk_id %d_window_id%
   }
   if d_Edit1Pos =  ; Wenn kein Edit1-Control gefunden ...
   {
      ; Ermitteln ob ein RichEdit-Control vorhanden ist (MS-Office)
      d_EditClass = RichEdit20W2
      ControlGetPos, d_Edit1Pos,,,, %d_EditClass% , ahk_id %d_window_id%
   }
 
   GetKeyState, ctrlState_ld, Ctrl ; Stauts der Strg-Taste ermitteln
 
   if ctrlState_ld = D ; wenn Strg-Taste gedrückt ...
   {
      ; Verzeichnis in Dateidialogen wechseln
      if d_class contains #32770,bosa_sdm
      {
         if d_Edit1Pos <>
         {
            WinActivate ahk_id %d_window_id%
            ControlGetText, d_text, %d_EditClass%, ahk_id %d_window_id%
            ControlSetText, %d_EditClass%, %d_path%, ahk_id %d_window_id%
            ControlSend   , %d_EditClass%, {Enter} , ahk_id %d_window_id%
            Sleep, 100
            ControlSetText, %d_EditClass%, %d_text%, ahk_id %d_window_id%
            return
         }
      }
 
      ; Verzeichnis in Explorer-Fenstern wechseln
      else if d_class in ExploreWClass,CabinetWClass
      {
         if d_Edit1Pos <>
         {
            ControlSetText, Edit1, %d_path%      , ahk_id %d_window_id%
            ControlSend   , Edit1, {Right}{Enter}, ahk_id %d_window_id%
            return
         }
      }
 
      ; Verzeichnis in AcdSee wechseln
      else if d_class = Afx:400000:0
      {
         if d_Edit1Pos <>
         {
            ControlSetText, Edit1, %d_path%, ahk_id %d_window_id%
            ControlSend   , Edit1, {Enter} , ahk_id %d_window_id%
            return
         }
      }
 
      ; Verzeichnis in FireFox wechseln
      else if d_class = FileZilla Main Window
      {
         if d_Edit1Pos <>
         {
            ControlSetText, Edit1, %d_path%, ahk_id %d_window_id%
            ControlSend   , Edit1, {Enter} , ahk_id %d_window_id%
            return
         }
      }
 
      ; Verzeichnis in der Eingabeaufforderung wechseln
      else if d_class = ConsoleWindowClass
      {
         WinGetActiveTitle, wTitle
         if wTitle contains cmd.exe
         {
            WinActivate, ahk_id %d_window_id%
            SetKeyDelay, 0
            IfInString, d_path, :
            {
               StringLeft, d_path_drive, d_path, 1
               Send %d_path_drive%:{enter}
            }
            Send, cd %d_path%{Enter}
            return
         }
      }
   }
 
   ; Wenn alles nicht passt oder Strg gedrückt war, einfach nur den Explorer aufrufen
   Run, Explorer %d_path%
return
 
Quit_ld:
   ExitApp
Return 