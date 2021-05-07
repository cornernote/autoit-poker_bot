#include-once
#include <GUIConstants.au3>
#include <GUIConstantsEx.au3>
#include <AutoItConstants.au3>
#include <FontConstants.au3>

Global $gui
Global $guiStreet
Global $giuCards[7]
Global $guiOpponents
Global $guiCanPlay
Global $guiCanAllIn
Global $guiCanRaise
Global $guiCanCall
Global $guiCanCheck
Global $guiCanFold
Global $guiAction


Func _GuiCreate()
   Opt("GUIOnEventMode", 1)

   $gui = GUICreate("Bot", 1920, 25, 0, 50, $WS_POPUP)

   $guiStreet = GUICtrlCreateButton("PREFLOP", 0, 0, 100)
   GUICtrlSetFont($guiStreet, 14, $FW_NORMAL, "", "")
   For $i=0 To 6
	  $giuCards[$i] = GUICtrlCreateButton("-", 100+30*$i, 0, 30)
	  GUICtrlSetFont($giuCards[$i], 14, $FW_NORMAL, "", "")
   Next
   $guiOpponents = GUICtrlCreateLabel("-", 330, 5, 150)
   GUICtrlSetFont($guiOpponents, 12, $FW_NORMAL, "", "Terminal")

   Local $size = 50
   $guiCanPlay = GUICtrlCreateButton("Play", 1920-$size*6, 0, $size)
   $guiCanAllIn = GUICtrlCreateButton("AllIn", 1920-$size*5, 0, $size)
   $guiCanRaise = GUICtrlCreateButton("Raise", 1920-$size*4, 0, $size)
   $guiCanCall = GUICtrlCreateButton("Call", 1920-$size*3, 0, $size)
   $guiCanCheck = GUICtrlCreateButton("Check", 1920-$size*2, 0, $size)
   $guiCanFold = GUICtrlCreateButton("Fold", 1920-$size*1, 0, $size)

   GUICtrlSetOnEvent($guiCanPlay, "_GuiCopyPlay")
   GUICtrlSetOnEvent($guiCanAllIn, "_GuiCopyAllIn")
   GUICtrlSetOnEvent($guiCanRaise, "_GuiCopyRaise")
   GUICtrlSetOnEvent($guiCanCall, "_GuiCopyCall")
   GUICtrlSetOnEvent($guiCanCheck, "_GuiCopyCheck")
   GUICtrlSetOnEvent($guiCanFold, "_GuiCopyFold")

   $guiAction = GUICtrlCreateButton("?", 1920-$size*8, 0, $size)

   GUISetState(@SW_SHOW, $gui)
   WinSetOnTop($gui, "", $WINDOWS_ONTOP)

EndFunc   ;==>_Gui

Func _GuiUpdate()
   _GuiUpdateButton($playFailChecksumPlay, $guiCanPlay)
   _GuiUpdateButton($playFailChecksumAllIn, $guiCanAllIn)
   _GuiUpdateButton($playFailChecksumRaise, $guiCanRaise)
   _GuiUpdateButton($playFailChecksumCall, $guiCanCall)
   _GuiUpdateButton($playFailChecksumCheck, $guiCanCheck)
   _GuiUpdateButton($playFailChecksumFold, $guiCanFold)
   _GuiUpdateCards()
   _GuiUpdateStreet()
   _GuiUpdateOpponents()
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
	  GUICtrlSetData($giuCards[$i], $number&$suit)
	  GUICtrlSetColor($giuCards[$i], $color)
   Next
EndFunc

Func _GuiUpdateStreet()
   GUICtrlSetData($guiStreet, _Street())
EndFunc

Func _GuiUpdateOpponents()
   GUICtrlSetData($guiOpponents, 'vs'&_OpponentsCount()&' '&_OpponentsString())
EndFunc

Func _GuiUpdateButton($check,$button)
   If $check Then
	  GUICtrlSetBkColor($button, 0x000000)
	  GUICtrlSetColor($button, 0xFFFFFF)
   Else
	  GUICtrlSetBkColor($button, 0xFFFFFF)
	  GUICtrlSetColor($button, 0x00FF00)
   EndIf
EndFunc


Func _GuiDelete()
    GUIDelete($gui)
EndFunc   ;==>_GuiDelete

Func _GuiCopyAllIn()
   _Log('_GuiCopyAllIn: '&$playFailChecksumAllIn)
   ClipPut($playFailChecksumAllIn)
EndFunc   ;==>_GuiCopyAllIn

Func _GuiCopyRaise()
   _Log('_GuiCopyRaise: '&$playFailChecksumRaise)
   ClipPut($playFailChecksumRaise)
EndFunc   ;==>_GuiCopyRaise

Func _GuiCopyCall()
   _Log('_GuiCopyCall: '&$playFailChecksumCall)
   ClipPut($playFailChecksumCall)
EndFunc   ;==>_GuiCopyCall

Func _GuiCopyCheck()
   _Log('_GuiCopyCheck: '&$playFailChecksumCheck)
   ClipPut($playFailChecksumCheck)
EndFunc   ;==>_GuiCopyCheck

Func _GuiCopyFold()
   _Log('_GuiCopyFold: '&$playFailChecksumFold)
   ClipPut($playFailChecksumFold)
EndFunc   ;==>_GuiCopyFold

Func _GuiCopyPlay()
   _Log('_GuiCopyPlay: '&$playFailChecksumPlay)
   ClipPut($playFailChecksumPlay)
EndFunc   ;==>_GuiCopyPlay


