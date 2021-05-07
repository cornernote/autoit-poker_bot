#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.14.5
 Author:         myName

#ce ----------------------------------------------------------------------------


#include "includes/Terminate.au3"
#include "includes/Pause.au3"
#include "includes/Ini.au3"
#include "includes/Log.au3"
#include "includes/Classify.au3"
#include "includes/Ocr.au3"
#include "includes/Window.au3"
#include "includes/Cards.au3"
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
; Gui - call/raise amounts, eval, im back/invite/popups, opponent buttons
; Lobby - ability to auto join game from home/lobby
; Opponent (opponent actions)
; Button (dealer buton position)
; Blind (read table blinds)
; Pot (read the main and side pot amount)
; Chat (room spam?)



; set hotkeys
HotKeySet("^!x", "_Terminate")
HotKeySet("^!p", "_PauseToggle")

; call init functions
_IniInit()
_CardsInit()
_ClassifyInit()
_GuiInit()

; loop forever
While 1

   ; scrape the data
   GUICtrlSetBkColor($guiPlay, 0xFFA500)
   _ClassifyOpen() ; ensure classifier is running
   _WindowRead()
   _CardsRead()
   _OpponentsRead()
   _ActionsRead()

   ; run player profile
   Call($ini_bot_profile)

   ; update gui and log
   _GuiUpdate()
   _LogUpdate()

   ; play profile action
   _PlayProfileAction()

   ; click window stuff
   GUICtrlSetBkColor($guiPlay, 0x008000)
   _WindowClosePopups()
   _WindowNextGame()

WEnd
