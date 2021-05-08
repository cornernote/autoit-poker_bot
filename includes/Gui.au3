#include-once
#include "vendors/AutoItExt/GUICtrlGetBkColor.au3"
#include <GUIConstants.au3>
#include <GUIConstantsEx.au3>
#include <AutoItConstants.au3>
#include <FontConstants.au3>
#include <Array.au3>
#include <WinAPISysWin.au3>

Global $gui
Global $guiBlind
Global $guiStreet
Global $giuCards[7]
Global $guiOpponents[8]
Global $guiVs
Global $guiEval
Global $guiAmountToCall
Global $guiAmountToRaise
Global $guiActions[5]
Global $guiPlay
Global $guiPause
Global $guiClose

Func _GuiInit()
   ; use interrupt events for buttons
   Opt("GUIOnEventMode", 1)

   ; create gui
   $gui = GUICreate("Bot", 1920, 25, 0, 50, $WS_POPUP, $WS_EX_LAYERED)
   GUISetOnEvent($GUI_EVENT_CLOSE, "_TerminateConfirm")
   GUISetOnEvent($GUI_EVENT_SECONDARYUP, "_GuiSecondaryUp")
   Local $x = 10

   ;
   ; left gui ($x+= after button)
   ;

   ; blind
   $guiBlind = GUICtrlCreateButton("-", $x, 0, 50)
   GUICtrlSetFont($guiBlind, 12, $FW_NORMAL, "", "")
   GUICtrlSetBkColor($guiBlind, 0xCCCCCC)
   GUICtrlSetOnEvent($guiBlind, "_GuiSetBlind")
   $x+=60

   ; street
   $guiStreet = GUICtrlCreateButton("-", $x, 0, 96)
   GUICtrlSetFont($guiStreet, 14, $FW_NORMAL, "", "")
   GUICtrlSetBkColor($guiStreet, 0xCCCCCC)
   GUICtrlSetOnEvent($guiStreet, "_Screenshot")
   $x+=106

   ; cards
   For $i=0 To UBound($giuCards) - 1
	  $giuCards[$i] = GUICtrlCreateButton("-", $x, 0, 28)
	  GUICtrlSetFont($giuCards[$i], 14, $FW_NORMAL, "", "")
	  $x+=28
	  If $i == 1 Then $x+=10
   Next
   $x+=10

   ; vs
   $guiVs = GUICtrlCreateButton("-", $x, 0, 50)
   GUICtrlSetFont($guiVs, 14, $FW_NORMAL, "", "")
   GUICtrlSetBkColor($guiVs, 0xCCCCCC)
   $x+=60

   ; opponents
   For $i=0 To UBound($guiOpponents) - 1
	  $guiOpponents[$i] = GUICtrlCreateButton("-", $x, 0, 20)
	  GUICtrlSetFont($guiOpponents[$i], 14, $FW_NORMAL, "", "")
	  GUICtrlSetBkColor($guiOpponents[$i], 0xCCCCCC)
      GUICtrlSetOnEvent($guiOpponents[$i], "_GuiToggleOpponentColor")
	  $x+=20
   Next
   $x+=10

   ; eval
   $guiEval = GUICtrlCreateButton("-", $x, 0, 150)
   GUICtrlSetFont($guiEval, 14, $FW_NORMAL, "", "")
   GUICtrlSetBkColor($guiEval, 0xCCCCCC)
   $x+=160

   ; amount to call
   $guiAmountToCall = GUICtrlCreateButton("-", $x, 0, 150)
   GUICtrlSetFont($guiAmountToCall, 14, $FW_NORMAL, "", "")
   GUICtrlSetBkColor($guiAmountToCall, 0xCCCCCC)
   $x+=160

   ; amount to raise
   $guiAmountToRaise = GUICtrlCreateButton("-", $x, 0, 150)
   GUICtrlSetFont($guiAmountToRaise, 14, $FW_NORMAL, "", "")
   GUICtrlSetBkColor($guiAmountToRaise, 0xCCCCCC)
   $x+=160

   ;
   ; right gui ($x+= before button)
   ;
   $x=10

   ; close
   $x+=20
   $guiClose = GUICtrlCreateButton("X", 1920-$x, 0, 20)
   GUICtrlSetFont($guiClose, 14, $FW_NORMAL, "", "")
   GUICtrlSetBkColor($guiClose, 0xCCCCCC)
   GUICtrlSetOnEvent($guiClose, "_TerminateConfirm")

   ; pause
   $x+=90
   $guiPause = GUICtrlCreateButton("PAUSED", 1920-$x, 0, 90)
   GUICtrlSetFont($guiPause, 14, $FW_NORMAL, "", "")
   GUICtrlSetColor($guiPause, 0xFFFFFF)
   GUICtrlSetBkColor($guiPause, 0xFF0000)
   GUICtrlSetOnEvent($guiPause, "_PauseToggle")

   ; play
   $x+=120
   $guiPlay = GUICtrlCreateButton("-", 1920-$x, 0, 110)
   GUICtrlSetFont($guiPlay, 14, $FW_NORMAL, "", "")
   GUICtrlSetBkColor($guiPlay, 0xCCCCCC)

   ; actions
   $x+=10
   For $i=0 To UBound($guiActions) - 1
	  $x+=60
	  $guiActions[$i] = GUICtrlCreateButton($actionCodes[$i], 1920-$x, 0, 60)
	  GUICtrlSetFont($guiActions[$i], 14, $FW_NORMAL, "", "")
	  GUICtrlSetBkColor($guiActions[$i], 0xCCCCCC)
	  GUICtrlSetColor($guiActions[$i], 0x999999)
	  GUICtrlSetOnEvent($guiActions[$i], "_GuiToggleActionChecksum")
   Next

   ; always on top
   WinSetOnTop($gui, "", $WINDOWS_ONTOP)

   ; transparent
   GUISetBkColor(0x0000F4, $gui)
   _WinAPI_SetLayeredWindowAttributes($gui, 0x0000F4)
   GuiSetState()

   ; start hidden
   _GuiHide()

EndFunc

Func _GuiDelete()
    GUIDelete($gui)
EndFunc

Func _GuiHide()
   GUISetState(@SW_HIDE, $gui)
EndFunc

Func _GuiShow()
   GUISetState(@SW_SHOW, $gui)
EndFunc

Func _GuiUpdate()
   If Not $ini_bot_debug Then
	  WinMove($gui, "", $window[0], $window[1]+50)
   EndIf
   _GuiSetValue($guiBlind, _GuiString($blind))
   _GuiSetValue($guiStreet, _Street())
   _GuiUpdateCards()
   _GuiSetValue($guiVs, 'vs '&_OpponentsCount())
   _GuiUpdateOpponents()
   _GuiSetValue($guiEval, 'eval:'&_GuiString(_HandEval(_Hand(), _OpponentsCount())))
   _GuiSetValue($guiAmountToCall, 'call:'&_GuiString($actionAmountToCall))
   _GuiSetValue($guiAmountToRaise, 'raise:'&_GuiString($actionAmountToRaise))
   _GuiUpdateActions()
   _GuiUpdatePlay()
   _GuiShow()
EndFunc

Func _GuiString($string)
   If Not $string Then Return ''
   Return String($string)
EndFunc

Func _GuiSetValue($guiId, $value)
   If GUICtrlRead($guiId) <> $value Then
	  GUICtrlSetData($guiId, $value)
   EndIf
EndFunc

Func _GuiUpdateCards()
   For $i=0 To UBound($cards) - 1
	  Local $number, $suit, $color
	  $color = 0xCCCCCC
	  $suit = ''
	  If $cards[$i][0] Then
		 $number = $cards[$i][0]
	  ElseIf $cards[$i][1] Then
         $number = "?"
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
			Case Else
			   $suit = '?'
			   $color = 0xFFFFFF
		 EndSwitch
	  ElseIf $cards[$i][1] Then
         $suit = "?"
	  EndIf
	  If GUICtrlRead($giuCards[$i]) <> $number&$suit Then
		 GUICtrlSetData($giuCards[$i], $number&$suit)
	  EndIf
	  GUICtrlSetColor($giuCards[$i], $color)
	  If $cardFailColor[$i] Then
		 If GUICtrlGetBkColor($giuCards[$i]) <> 0xCCCCCC Then
			GUICtrlSetBkColor($giuCards[$i], 0xCCCCCC)
		 EndIf
	  ElseIf $suit == '?' Then
		 If GUICtrlGetBkColor($giuCards[$i]) <> 0xFFA500 Then
			GUICtrlSetBkColor($giuCards[$i], 0xFFA500)
		 EndIf
	  Else
		 If GUICtrlGetBkColor($giuCards[$i]) <> 0xFFFFFF Then
			GUICtrlSetBkColor($giuCards[$i], 0xFFFFFF)
		 EndIf
	  EndIf
   Next
EndFunc

Func _GuiUpdateOpponents()
   For $i=0 To UBound($opponents) - 1
	  Local $value = ' '
	  If $opponents[$i] Then
		 $value = $i+1
	  EndIf
	  If GUICtrlRead($guiOpponents[$i]) <> $value Then
		 GUICtrlSetData($guiOpponents[$i], $value)
	  EndIf
   Next
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

Func _GuiUpdatePlay()
   Local $value = $profilePlayAction
   If $value == 'call' Then
	  $value = $value&':'&$profilePlayMaximumCallAmount
   ElseIf $value == 'raise' Then
	  $value = $value&':'&$profilePlaRaiseAmount
   EndIf
   _GuiSetValue($guiPlay, $value)
EndFunc

Func _GuiToggleActionChecksum()
   Local $ctrlId = @GUI_CtrlId
   For $i=0 To UBound($actionFailChecksum)-1
	  If $ctrlId==$guiActions[$i] Then
		 If Not $actionFailChecksum[$i] Then
			MsgBox($MB_OK, "Error" ,"No checksum found in "&$actionCodes[$i]&"!")
			Return
		 EndIf
		 Local $confirm = MsgBox($MB_YESNO, "Confirm" ,"Add "&$actionFailChecksum[$i]&" to "&$actionCodes[$i]&"?")
		 If $confirm <> $IDYES Then
			Return
		 EndIf
		 _Log('_GuiToggleActionChecksum('&$actionCodes[$i]&'): '&$actionFailChecksum[$i])
		 ; load ini checksums
		 Local $code = $actionCodes[$i]
		 Local $checksums = StringSplit(Eval("ini_action_"&$code&"_checksums"), ",")
		 Local $size = UBound($checksums)
		 ; add checksum to list
		 ReDim $checksums[$size+1]
		 $checksums[$size] = $actionFailChecksum[$i]
		 ; remove duplicate checksums
		 $checksums = _ArrayUnique($checksums)
		 ; save new checksums to ini
		 Local $value = _ArrayToString($checksums, ",")
		 Assign("ini_action_"&$code&"_checksums", $value, $ASSIGN_FORCEGLOBAL)
		 IniWrite (@ScriptDir & "\settings.ini", "action", $code&"_checksums", $value)
		 ClipPut($actionFailChecksum[$i])
	  EndIf
   Next
EndFunc

Func _GuiSetBlind()
   Local $blind = InputBox("Set Room Blind", "What is the Big Blind Amount in this room?")
   If Not $blind Then Return
   _Log($blind)
   ;_BlindRoomSave($blind)
EndFunc

Func _GuiSecondaryUp()
   $cursor = GUIGetCursorInfo($gui)
;   If $cursor[4] == $guiBlind Then
;	  Local $confirm = MsgBox($MB_OKCANCEL, "Set Blind Position", "Click the top left of the blind area.")
;	  If $confirm <> $IDYES Then
;		 Return
;	  EndIf
;   EndIf
EndFunc

