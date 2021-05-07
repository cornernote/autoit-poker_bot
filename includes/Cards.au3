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

; read card numbers and suits
Func _Cards()
   For $i = 0 To UBound($cards, $UBOUND_ROWS) - 1
	  If _Card($i) Then
         $cards[$i][0] = _CardNumber($i)
         $cards[$i][1] = _CardSuit($i)
	  Else
		 $cards[$i][0] = False
		 $cards[$i][1] = False
	  EndIf
   Next
EndFunc   ;==>_Cards

; check if a card is visable
Func _Card($cardIndex)
   Local $x = $windowPos[0]+Int(IniRead(@ScriptDir & "\settings.ini","card",($cardIndex+1)&"_number_x", 0))
   Local $y = $windowPos[1]+Int(IniRead(@ScriptDir & "\settings.ini","card",($cardIndex+1)&"_number_y", 0))
   Local $color = Int(IniRead(@ScriptDir & "\settings.ini","card",($cardIndex+1)&"_color", 0))
   ;_DrawRect($x-2, $y-2, $x+2, $y+2, 0x0000FF)
   ;_Log("_CardNumber " & $cardIndex & ":" & PixelGetColor($x, $y) & " <> " & $color)
   Return PixelGetColor($x, $y) == $color
EndFunc   ;==>_Card

; get a card number
Func _CardNumber($cardIndex)
   Local $x = $windowPos[0]+Int(IniRead(@ScriptDir & "\settings.ini","card",($cardIndex+1)&"_number_x", 0))
   Local $y = $windowPos[1]+Int(IniRead(@ScriptDir & "\settings.ini","card",($cardIndex+1)&"_number_y", 0))
   Local $checksum = _CardChecksum($cardIndex, $x, $y, $x + 29, $y + 29)
   If Not $checksum Then
	  Return
   EndIf
   Local $card = _CardCode($checksum)
   Local $path = @ScriptDir & "\data\card"
   If Not $card And Not FileExists($path & "\X\" & $checksum & ".png") Then
	  DirCreate($path & "\X")
	  ;_DrawRect($x, $y, $x + 29, $y + 29, 0x0000FF)
      _ScreenCapture_Capture($path & "\" & $checksum & ".png", $x, $y, $x + 29, $y + 29, False)
	  Sleep(100)
      $card = _CardCode($checksum)
   EndIf
   Return $card
EndFunc   ;==>_CardNumber

; get a card suit
Func _CardSuit($cardIndex)
   Local $x = $windowPos[0]+Int(IniRead(@ScriptDir & "\settings.ini","card",($cardIndex+1)&"_suit_x", 0))
   Local $y = $windowPos[1]+Int(IniRead(@ScriptDir & "\settings.ini","card",($cardIndex+1)&"_suit_y", 0))
   Local $checksum = _CardChecksum($cardIndex, $x, $y, $x + 19, $y + 19)
   If Not $checksum Then
	  Return
   EndIf
   Local $suit = _CardCode($checksum)
   Local $path = @ScriptDir & "\data\card"
   If Not $suit And Not FileExists($path & "\X\" &  $checksum & ".png") Then
	  DirCreate($path & "\X")
	  ;_DrawRect($x, $y, $x + 19, $y + 19, 0x0000FF)
      _ScreenCapture_Capture($path & "\" & $checksum & ".png", $x, $y, $x + 19, $y + 19, False)
	  Sleep(100)
      $suit = _CardCode($checksum)
   EndIf
   Return $suit
EndFunc   ;==>_CardSuit

; get a card number/suit
Func _CardCode($checksum)
   Local $path = @ScriptDir & "\data\card"
   For $i = 0 To UBound($cardCodes) - 1
	  DirCreate($path & "\" & $cardCodes[$i])
	  If FileExists($path & "\" & $cardCodes[$i] & "\" & $checksum & ".png") Then
	     Return $cardCodes[$i]
	  EndIf
   Next
EndFunc   ;==>_CardCode

; get checksum of an area, ensuring no animation
Func _CardChecksum($cardIndex, $x1, $y1, $x2, $y2)
   If Not _Card($cardIndex) Then
	  Return
   EndIf
   Local $checksum = PixelChecksum($x1, $y1, $x2, $y2)
   ;Sleep(50)
   ;If $checksum <> PixelChecksum($x1, $y1, $x2, $y2) Then
   ;   Return _CardChecksum($cardIndex, $x1, $y1, $x2, $y2)
   ;EndIf
   Return $checksum
EndFunc

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
