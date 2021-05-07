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
#include "includes/Profiles.au3"
#include "includes/Gui.au3"
#include "includes/Screenshot.au3"


;
; TODO
; Blind (read table blinds)
; Gui - im back/invite/etc
; Lobby - ability to auto join game from home/lobby, ability to detect bad table and leave room
; Opponent (opponent actions)
; Button (dealer buton position)
; Pot (read the main and side pot amount)
; Chat (room spam?)



; set hotkeys
HotKeySet("^!x", "_Terminate")
HotKeySet("^!p", "_PauseToggle")

; init
_IniInit()
_CardsInit()
_ClassifyInit()
_GuiInit()

; loop forever
While 1
   GUICtrlSetBkColor($guiPlay, 0xFFA500)
   _ClassifyOpen() ; ensure classifier is running

   ; scrape some data
   _WindowRead()
   _BlindRead()
   _CardsRead()
   _OpponentsRead()
   _ActionsRead()

   ; run player profile
   Call($ini_bot_profile)

   ; update gui and log
   _GuiUpdate()
   _LogUpdate()

   ; take some action, click some stuff, maybe...
   GUICtrlSetBkColor($guiPlay, 0x008000)
   _PlayProfileAction()
   _WindowClosePopups()
   _WindowNextGame()
WEnd
