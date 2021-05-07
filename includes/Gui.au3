#include-once
#include <GUIConstants.au3>
#include <GUIConstantsEx.au3>
#include <AutoItConstants.au3>
#include <FontConstants.au3>

Global $gui
Global $guiStreet
Global $giuCards[7]
Global $guiOpponents
Global $guiActions[5]
Global $guiPlay
Global $guiPause


Func _GuiInit()
   ; use interrupt events for buttons
   Opt("GUIOnEventMode", 1)

   ; create gui, always on top
   $gui = GUICreate("Bot", 1920, 25, 0, 50, $WS_POPUP)
   WinSetOnTop($gui, "", $WINDOWS_ONTOP)

   ; street
   $guiStreet = GUICtrlCreateButton("-", 0, 0, 100)
   GUICtrlSetFont($guiStreet, 14, $FW_NORMAL, "", "")

   ; cards
   For $i=0 To 1
	  $giuCards[$i] = GUICtrlCreateButton("-", 110+30*$i, 0, 30)
	  GUICtrlSetFont($giuCards[$i], 14, $FW_NORMAL, "", "")
      GUICtrlSetOnEvent($giuCards[$i], "_GuiCopyCard")
   Next
   For $i=2 To 6
	  $giuCards[$i] = GUICtrlCreateButton("-", 120+30*$i, 0, 30)
	  GUICtrlSetFont($giuCards[$i], 14, $FW_NORMAL, "", "")
      GUICtrlSetOnEvent($giuCards[$i], "_GuiCopyCard")
   Next

   ; opponents
   $guiOpponents = GUICtrlCreateLabel("-", 340, 5, 150)
   GUICtrlSetFont($guiOpponents, 12, $FW_NORMAL, "", "Terminal")

   ; actions
   For $i=0 To UBound($guiActions) - 1
	  $guiActions[$i] = GUICtrlCreateButton($actionCodes[$i], 1920-50*($i+1), 0, 50)
	  GUICtrlSetOnEvent($guiActions[$i], "_GuiCopyAction")
   Next

   ; play
   $guiPlay = GUICtrlCreateButton("-", 1920-50*(UBound($guiActions)+1), 0, 50)

   ; pause
   $guiPause = GUICtrlCreateButton("PAUSED", 1920-50*(UBound($guiActions)+3), 0, 100)
   GUICtrlSetColor($guiPause, 0xFFFFFF)
   GUICtrlSetBkColor($guiPause, 0xFF0000)
   GUICtrlSetOnEvent($guiPause, "TogglePause")

   ; show gui
   GUISetState(@SW_SHOW, $gui)

EndFunc   ;==>_GuiInit

Func _GuiUpdate()
   WinMove($gui, "", $window[0], $window[1]+50)
   _GuiUpdateStreet()
   _GuiUpdateCards()
   _GuiUpdateOpponents()
   _GuiUpdateActions()
EndFunc

Func _GuiUpdateCards()
   For $i=0 To UBound($cards) - 1
	  Local $number, $suit, $color
	  $color = 0xCCCCCC
	  $suit = ''
	  If $cards[$i][0] Then
		 $number = $cards[$i][0]
	  Else
         $number = " "
	  EndIf
	  If $cards[$i][1] Then
		 Switch $cards[$i][1]
			Case 'h':
			   $suit = '♥'
			   $color = 0xFF0000
			Case 'd':
			   $suit = '♦'
			   $color = 0x0000FF
			Case 'c':
			   $suit = '♣'
			   $color = 0x008000
			Case 's':
			   $suit = '♠'
			   $color = 0x000000
		 EndSwitch
	  EndIf
	  If GUICtrlRead($giuCards[$i]) <> $number&$suit Then
		 GUICtrlSetData($giuCards[$i], $number&$suit)
	  EndIf
	  ;ControlSetText($gui, "", $giuCards[$i], $number&$suit, 0)
	  GUICtrlSetColor($giuCards[$i], $color)
	  If $cardFailColor[$i] Then
		 If GUICtrlGetBkColor($giuCards[$i]) <> 0x000000 Then
			GUICtrlSetBkColor($giuCards[$i], 0x000000)
		 EndIf
	  Else
		 If GUICtrlGetBkColor($giuCards[$i]) <> 0xFFFFFF Then
			GUICtrlSetBkColor($giuCards[$i], 0xFFFFFF)
		 EndIf
	  EndIf
   Next
EndFunc

Func _GuiUpdateStreet()
   GUICtrlSetData($guiStreet, _Street())
EndFunc

Func _GuiUpdateOpponents()
   GUICtrlSetData($guiOpponents, 'vs'&_OpponentsCount()&' '&_OpponentsString())
EndFunc

Func _GuiUpdateActions()
   For $i=0 To UBound($actions) - 1
	  If $actions[$i] Then
		 If GUICtrlGetBkColor($guiActions[$i]) <> 0x008000 Then
			GUICtrlSetBkColor($guiActions[$i], 0x008000)
			GUICtrlSetColor($guiActions[$i], 0x000000)
		 EndIf
	  Else
		 If GUICtrlGetBkColor($guiActions[$i]) <> 0xCCCCCC Then
			GUICtrlSetBkColor($guiActions[$i], 0xCCCCCC)
			GUICtrlSetColor($guiActions[$i], 0x999999)
		 EndIf
	  EndIf
   Next
EndFunc



Func _GuiDelete()
    GUIDelete($gui)
EndFunc   ;==>_GuiDelete

Func _GuiCopyAction()
   Local $ctrlId = @GUI_CtrlId
   For $i=0 To UBound($actionFailChecksum)-1
	  If $ctrlId==$guiActions[$i] Then
		 _Log('_GuiCopyAction('&$actionCodes[$i]&'): '&$i)
		 ClipPut($actionFailChecksum[$i])
	  EndIf
   Next
EndFunc   ;==>_GuiCopyPlay

Func _GuiCopyCard($cardIndex=0)
   _Log('_GuiCopyCard: '&$cardFailColor[$cardIndex])
   ClipPut($cardFailColor[$cardIndex])
EndFunc   ;==>_GuiCopyCard


