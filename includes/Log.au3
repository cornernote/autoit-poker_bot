#include-once

#include <Array.au3>

Func _Log($value)
   Local $date = (@YEAR & "-" & @MON & "-" & @MDAY & "-" & @HOUR & "-" & @MIN & "-" & @SEC & "-" & @MSEC)
  ;$filename = $logPath&'\log_'&(@YEAR & "-" & @MON & "-" & @MDAY & "-" & @HOUR)&'.txt'
  ;FileWriteLine($filename,$date&': '&_DebugArray($value))
  If IsArray($value) Then
   ConsoleWrite($date&': '&_ArrayToString($value)&@CRLF)
  Else
   ConsoleWrite($date&': '&($value)&@CRLF)
  EndIf
EndFunc

Func _LogUpdate()
   _Log($ini_bot_profile&"[" & StringLeft(_Street(),1) & "][" & _CardsString() & "] vs" & _OpponentsCount() & " [" & _OpponentsString() & "] eval=" & _HandEval(_Hand(), _OpponentsCount()) & " ["&_ActionsString()&"] [call="&$actionAmountToCall&"|raise="&$actionAmountToRaise&"]")
EndFunc

