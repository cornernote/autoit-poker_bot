#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.14.5
 Author:         myName

#ce ----------------------------------------------------------------------------


#include "includes/Debug.au3"
#include "includes/Ini.au3"
#include "includes/Classify.au3"
#include "includes/Ocr.au3"
#include "includes/Window.au3"
#include "includes/Cards.au3"
#include "includes/Opponents.au3"
#include "includes/Actions.au3"
#include "includes/Amount.au3"
#include "includes/Hand.au3"
#include "includes/Street.au3"
#include "includes/Play.au3"
#include "includes/Profiles.au3"
#include "includes/Gui.au3"

#include "includes/vendors/AutoIt/GUICtrlGetBkColor.au3"

;
; TODO
; Gui - screenshot, eval, opponent buttons, buttons toggle (saves to ini instead of clipboard)
; Lobby - ability to auto join game from home/lobby
; Action (opponent actions and raise amount)
; Button position (dealer buton)
; Chat Functions
; Blind (read table blinds)
; Pot (read the main and side pot amount)


;=================================================================
; Kill Switch
;=================================================================
HotKeySet("^!x", "Terminate")
Func Terminate()
   _Log('Terminating')
   _ClassifyClose()
   _GuiDelete()
   _Log('Terminated')
   Exit
EndFunc

;=================================================================
; Pause Switch
;=================================================================
HotKeySet("^!p", "TogglePause")
Global $paused = True
Func TogglePause()
   If $paused == False Then
	  $paused = True
      _Log('Paused')
	  GUICtrlSetData($guiPause, 'PAUSED')
	  GUICtrlSetBkColor($guiPause, 0xFF0000)
   Else
	  $paused = False
      _Log('Running')
	  GUICtrlSetData($guiPause, 'PLAYING')
	  GUICtrlSetBkColor($guiPause, 0x008000)
   EndIf
EndFunc

;=================================================================
; Main Driver
;=================================================================
_IniInit()
_CardsInit()
_ClassifyInit()
_GuiInit()
While 1
   _ClassifyOpen()
   ;For $i=1 To 5 ; main loop a few times
	  GUICtrlSetBkColor($guiPlay, 0xFF0000)
	  _Window()
	  _CardsRead()
	  _OpponentsRead()
	  _ActionsRead()
	  _GuiUpdate()

	  _Log($ini_bot_profile&"[" & StringLeft(_Street(),1) & "][" & _CardsString() & "] vs" & _OpponentsCount() & " [" & _OpponentsString() & "] eval=" & _HandEval(_Hand(), _OpponentsCount()) & " ["&_ActionsString()&"]")

	  Call($ini_bot_profile)
	  GUICtrlSetBkColor($guiPlay, 0x0000FF)
	  Sleep(50)
   ;Next
   ; next game screen
   GUICtrlSetBkColor($guiPlay, 0x000000)
   _WindowNextGame()
WEnd
Terminate()
