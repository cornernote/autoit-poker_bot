#include-once

#include <Array.au3>
#include <AutoItConstants.au3>
#include <File.au3>
#include <ScreenCapture.au3>
#include <StringConstants.au3>


; define card positions
Global $opponentPos[8][3]
For $i = 0 To UBound($opponentPos, $UBOUND_ROWS) - 1
   $opponentPos[$i][0] = Int(IniRead(@ScriptDir & "\settings.ini","opponent",($i+1)&"_sitting_x", 0))
   $opponentPos[$i][1] = Int(IniRead(@ScriptDir & "\settings.ini","opponent",($i+1)&"_sitting_y", 0))
   $opponentPos[$i][2] = Int(IniRead(@ScriptDir & "\settings.ini","opponent",($i+1)&"_sitting_color", 0))
Next

; get info about opponents
Func _Opponents()
   Local $opponents[8]
   For $i = 0 To UBound($opponentPos, $UBOUND_ROWS) - 1
	  $opponents[$i] = _OpponentSitting($i)
   Next
   Return $opponents
EndFunc   ;==>_Opponents

; get number of opponents
Func _OpponentsCount($opponents)
   Local $opponentsCount = 0
   For $i = 0 To UBound($opponents, $UBOUND_ROWS) - 1
	  If $opponents[$i] Then
         $opponentsCount = $opponentsCount+1
	  EndIf
   Next
   Return $opponentsCount
EndFunc   ;==>_OpponentsCount

; is opponent sitting
Func _OpponentSitting($opponentIndex)
   Local $x = $windowPos[0]+$opponentPos[$opponentIndex][0]
   Local $y = $windowPos[1]+$opponentPos[$opponentIndex][1]
   Local $color = $opponentPos[$opponentIndex][2]
   If PixelGetColor($x, $y) <> $color Then
   ;_DrawRect($x-2, $y-2, $x+2, $y+2, 0x0000FF)
   ;_Log("_OpponentSitting " & ($opponentIndex+1) & ":" & PixelGetColor($x, $y) & " <> " & $color)
   EndIf
   Return PixelGetColor($x, $y) == $color
EndFunc   ;==>_OpponentSitting


; convert opponent array to string
Func _OpponentsString($opponents)
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
