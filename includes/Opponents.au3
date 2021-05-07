#include-once

#include <Array.au3>
#include <AutoItConstants.au3>
#include <File.au3>
#include <ScreenCapture.au3>
#include <StringConstants.au3>

; stores the read opponents
Global $opponents[8]

; get info about opponents
Func _OpponentsRead()
   _OpponentsReset()
   For $i = 0 To UBound($opponents) - 1
	  $opponents[$i] = _OpponentSitting($i)
   Next
EndFunc   ;==>_Opponents

; reset opponents array
Func _OpponentsReset()
   For $i = 0 To UBound($opponents) - 1
	  $opponents[$i] = False
   Next
EndFunc   ;==>_OpponentsReset

; is opponent sitting
Func _OpponentSitting($opponentIndex)
   Local $x = $window[0]+Eval("ini_opponent_"&($opponentIndex+1)&"_sitting_x")
   Local $y = $window[1]+Eval("ini_opponent_"&($opponentIndex+1)&"_sitting_y")
   Local $color = Eval("ini_opponent_"&($opponentIndex+1)&"_sitting_color")
   ;If PixelGetColor($x, $y) <> $color Then
   ;_DrawRect($x-2, $y-2, $x+2, $y+2, 0x0000FF)
   ;_Log("_OpponentSitting " & ($opponentIndex+1) & ":" & PixelGetColor($x, $y) & " <> " & $color)
   ;EndIf
   Return PixelGetColor($x, $y) == $color
EndFunc   ;==>_OpponentSitting

; get number of opponents
Func _OpponentsCount()
   Local $opponentsCount = 0
   For $i = 0 To UBound($opponents, $UBOUND_ROWS) - 1
	  If $opponents[$i] Then
         $opponentsCount = $opponentsCount+1
	  EndIf
   Next
   Return $opponentsCount
EndFunc   ;==>_OpponentsCount

; convert opponent array to string
Func _OpponentsString()
   Local $string
   For $i = 0 To UBound($opponents, $UBOUND_ROWS) - 1
	  If $opponents[$i] Then
         $string = $string & ($i+1)
	  Else
         $string = $string & "-"
	  EndIf
	  ;$string = $string & " "
   Next
   ;$string = StringStripWS($string, $STR_STRIPTRAILING)
   Return $string
EndFunc   ;==>_OpponentsString
