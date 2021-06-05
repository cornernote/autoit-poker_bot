#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.14.5
 Author:         myName

#ce ----------------------------------------------------------------------------


#include "includes/Terminate.au3"
#include "includes/Pause.au3"
#include "includes/Ini.au3"
#include "includes/Log.au3"
#include "includes/Amount.au3"
#include "includes/Classify.au3"
#include "includes/Ocr.au3"
#include "includes/Window.au3"
#include "includes/Cards.au3"
#include "includes/Blind.au3"
#include "includes/Opponents.au3"
#include "includes/Actions.au3"
#include "includes/Hand.au3"
#include "includes/Street.au3"
#include "includes/Play.au3"
#include "includes/Profile.au3"
#include "includes/Gui.au3"
#include "includes/Screenshot.au3"


;
; TODO
; Player - ini configurable player
; Timer - log timing info
; Blind (read table blinds)
; Gui - im back/invite/etc
; Lobby - ability to auto join game from home/lobby, ability to detect bad table and leave room
; Opponent (opponent actions)
; Button (dealer buton position)
; Pot (read the main and side pot amount)
; Chat (room spam?)

; set hotkeys
HotKeySet("^q", "_Terminate")
HotKeySet("^p", "_PauseToggle")


; init
Func Init()
   _IniInit()
   _LogInit()
   _CardsInit()
   _ClassifyInit()
   _ProfileInit()
   _GuiInit()
EndFunc

; read screen data
;_ClassifyCheck(); _CardsRead(); _OpponentsRead(); etc
Func Read()
   Local $functions[9] = ['_WindowClosePopups','_ClassifyCheck','_WindowRead','_BlindRead','_CardsRead','_OpponentsRead','_ActionsRead',$ini_bot_profile,'_GuiUpdate']
   Local $timers[UBound($functions)]
   Local $timerId = 0
   For $i=0 To UBound($functions) - 1
	  Local $timer = TimerInit()
	  Call($functions[$i])
	  If $functions[$i]=='_WindowRead' Then
		 If Not $ini_bot_debug And Not $window[3] Then
			_GuiHide()
			ContinueLoop
		 EndIf
	  EndIf
	  $timers[$i] = TimerDiff($timer)
   Next
   ; update log
   ;_Log($timers)
   _LogUpdate()
EndFunc

; take some action, click some stuff, maybe...
Func Play()
   _PlayProfileAction()
   _WindowClosePopups()
   _WindowNextGame()
EndFunc

; loop forever
Init()
While 1
   GUICtrlSetBkColor($guiPlay, 0xFFA500)
   Read()
   GUICtrlSetBkColor($guiPlay, 0x008000)
   Play()
WEnd
