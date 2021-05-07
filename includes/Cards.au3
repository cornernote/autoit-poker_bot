;=================================================================
; Read the Cards
;=================================================================
#include-once

#include <Array.au3>
#include <AutoItConstants.au3>
#include <File.au3>
#include <ScreenCapture.au3>
#include <StringConstants.au3>
#include <Constants.au3>

; stores the read cards
Global $cards[7][2]

; define number and suit checksum maps
Global $cardCodes[17] = ["2","3","4","5","6","7","8","9","T","J","Q","K","A","H","D","C","S"]

; used to get color if the match fails
Global $cardFailColor[7]

; create folders
Func _CardsInit()
   Local $path = @ScriptDir & "\data\card"
   DirCreate($path & "\X")
   For $i = 0 To UBound($cardCodes) - 1
	  DirCreate($path & "\" & $cardCodes[$i])
   Next
EndFunc   ;==>_CardInit

; reset cards array
Func _CardsReset()
   For $i = 0 To UBound($cards, $UBOUND_ROWS) - 1
	  $cards[$i][0] = False
	  $cards[$i][1] = False
   Next
EndFunc   ;==>_CardsReset

; read card numbers and suits
Func _CardsRead()
   ;Local $timer = TimerInit()
   _CardsReset()
   For $i = 0 To UBound($cards, $UBOUND_ROWS) - 1
	  If _Card($i) Then
         $cards[$i][0] = _CardNumber($i)
         $cards[$i][1] = _CardSuit($i)
	  EndIf
   Next
   ;_Log('_Cards():'&TimerDiff($timer))
EndFunc   ;==>_Cards

; check if a card is visable
Func _Card($cardIndex)
   ;Local $timer = TimerInit()
   Local $x = $window[0]+Eval("ini_card_"&($cardIndex+1)&"_number_x")
   Local $y = $window[1]+Eval("ini_card_"&($cardIndex+1)&"_number_y")
   Local $color = Eval("ini_card_"&($cardIndex+1)&"_color")
   ;_DrawRect($x-2, $y-2, $x+2, $y+2, 0x0000FF)
   ;_Log("_CardNumber " & $cardIndex & ":" & PixelGetColor($x, $y) & " <> " & $color)
   Local $result
   Local $currentColor = PixelGetColor($x, $y)
   If $currentColor == $color Then
	  $result = True
	  $cardFailColor[$cardIndex] = False
   Else
	  $cardFailColor[$cardIndex] = $currentColor
   EndIf
   ;_Log('_Card('&$cardIndex&'):'&TimerDiff($timer))
   Return $result
EndFunc   ;==>_Card

; get a card number
Func _CardNumber($cardIndex)
   ;Local $timer = TimerInit()
   Local $x = $window[0]+Eval("ini_card_"&($cardIndex+1)&"_number_x")
   Local $y = $window[1]+Eval("ini_card_"&($cardIndex+1)&"_number_y")
   Local $checksum = PixelChecksum($x, $y, $x + 29, $y + 29)
   If Not $checksum Then
	  Return
   EndIf
   Local $card = _CardCode($checksum)
   Local $path = @ScriptDir & "\data\card"
   If Not $card And Not FileExists($path & "\X\" & $checksum & ".png") Then
	  _Log('unknown card (index:'&$cardIndex&'):'&$checksum)
	  If Not FileExists($path & "\" & $checksum & ".png") Then
		 ;_DrawRect($x, $y, $x + 29, $y + 29, 0x0000FF)
		 _ScreenCapture_Capture($path & "\" & $checksum & ".png", $x, $y, $x + 29, $y + 29, False)
	  EndIf
	  ;Sleep(100)
      ;$card = _CardCode($checksum)
   EndIf
   ;_Log('_CardNumber('&$cardIndex&'):'&TimerDiff($timer))
   Return $card
EndFunc   ;==>_CardNumber

; get a card suit
Func _CardSuit($cardIndex)
   ;Local $timer = TimerInit()
   Local $x = $window[0]+Eval("ini_card_"&($cardIndex+1)&"_suit_x")
   Local $y = $window[1]+Eval("ini_card_"&($cardIndex+1)&"_suit_y")
   Local $checksum = PixelChecksum($x, $y, $x + 19, $y + 19)
   If Not $checksum Then
	  Return
   EndIf
   Local $suit = _CardCode($checksum)
   Local $path = @ScriptDir & "\data\card"
   If Not $suit And Not FileExists($path & "\X\" &  $checksum & ".png") Then
	  _Log('unknown suit (index:'&$cardIndex&'):'&$checksum)
	  If Not FileExists($path & "\" & $checksum & ".png") Then
		 ;_DrawRect($x, $y, $x + 19, $y + 19, 0x0000FF)
		 _ScreenCapture_Capture($path & "\" & $checksum & ".png", $x, $y, $x + 19, $y + 19, False)
	  EndIf
	  ;Sleep(100)
      ;$suit = _CardCode($checksum)
   EndIf
   ;_Log('_CardSuit('&$cardIndex&'):'&TimerDiff($timer))
   Return $suit
EndFunc   ;==>_CardSuit

; get a card number/suit
Func _CardCode($checksum)
   Local $path = @ScriptDir & "\data\card"
   For $i = 0 To UBound($cardCodes) - 1
	  If FileExists($path & "\" & $cardCodes[$i] & "\" & $checksum & ".png") Then
	     Return $cardCodes[$i]
	  EndIf
   Next
EndFunc   ;==>_CardCode

; get checksum of an area, ensuring no animation
;Func _CardChecksum($cardIndex, $x1, $y1, $x2, $y2)
;   If Not _Card($cardIndex) Then
;	  Return
;   EndIf
;   Local $checksum = PixelChecksum($x1, $y1, $x2, $y2)
;   ;Sleep(50)
;   ;If $checksum <> PixelChecksum($x1, $y1, $x2, $y2) Then
;   ;   Return _CardChecksum($cardIndex, $x1, $y1, $x2, $y2)
;   ;EndIf
;   Return $checksum
;EndFunc

; convert card array to string
Func _CardsString()
   Local $string
   For $i = 0 To UBound($cards, $UBOUND_ROWS) - 1
	  If $cards[$i][0] Then
         $string = $string & $cards[$i][0]
	  Else
         $string = $string & "-"
	  EndIf
	  If $cards[$i][1] Then
         $string = $string & StringLower($cards[$i][1])
	  Else
         $string = $string & "-"
	  EndIf
	  $string = $string & " "
   Next
   $string = StringStripWS($string, $STR_STRIPTRAILING)
   Return $string
EndFunc   ;==>_CardsString
