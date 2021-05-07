#include-once
#include <GUIConstants.au3>
#include <GUIConstantsEx.au3>
#include <AutoItConstants.au3>
#include <FontConstants.au3>

Global $gui
Global $guiCardLabel
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

   $guiCardLabel = GUICtrlCreateLabel("-guiCardLabel-", 10, 5, 1000)
   GUICtrlSetFont($guiCardLabel, 12, $FW_NORMAL, "", "Terminal")

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


