#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.14.5
 Author:         myName

#ce ----------------------------------------------------------------------------


#Include "includes/Debug.au3"
#Include "includes/Classify.au3"
#Include "includes/Ocr.au3"
#Include "includes/Window.au3"
#Include "includes/Cards.au3"
#Include "includes/Amount.au3"
#Include "includes/Opponents.au3"
#Include "includes/Hand.au3"
#Include "includes/Street.au3"
#Include "includes/Play.au3"
#Include "includes/Profiles.au3"
#Include "includes/Gui.au3"

#include <MsgBoxConstants.au3>
#include <TrayConstants.au3>
#include <AutoItConstants.au3>

;
; TODO
; Ini - load all ini vars at init
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
HotKeySet("^!p", "TogglePokerbot")
Global $paused = False
Func TogglePokerbot()
   If $paused == False Then
      _Log('Paused')
	  $paused = True
   Else
      _Log('Unpaused')
	  $paused = False
   EndIf
EndFunc

;=================================================================
; Main Driver
;=================================================================

_ClassifyClose()
_GuiCreate()
While 1
   For $i=1 To 3 ; main loop for 5 times
	  GUICtrlSetBkColor($guiAction, 0xFF0000)
	  _ClassifyOpen()
	  _Window()
	  Local $profile = IniRead(@ScriptDir & "\settings.ini","bot","profile", "")
	  Call($profile)
	  GUICtrlSetBkColor($guiAction, 0x0000FF)
	  Sleep(50)
   Next
   ; next game screen
   GUICtrlSetBkColor($guiAction, 0x000000)
   _WindowNextGame()
WEnd
Terminate()