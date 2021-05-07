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

; logs data in the main loop
Func _LogUpdate()
   _Log(_LogString())
EndFunc

; logs a played action
Func _LogPlay($extra)
   Local $date = (@YEAR & "-" & @MON & "-" & @MDAY & "-" & @HOUR & "-" & @MIN & "-" & @SEC & "-" & @MSEC)
   Local $path = @ScriptDir & "\data\action"
   DirCreate($path)
   _ScreenCapture_Capture($path & "\" & $date & ".png", $window[0], $window[1], $window[0]+$window[2]-1, $window[1]+$window[3]-1, False)
   FileWriteLine($path & "\" & (@YEAR & "-" & @MON & "-" & @MDAY) & ".txt", $date&': '&_LogString()&" "&$extra)
EndFunc

Func _LogString()
   Return $ini_bot_profile&"[" & StringLeft(_Street(),1) & "][" & _CardsString() & "] vs" & _OpponentsCount() & " [" & _OpponentsString() & "] eval=" & _HandEval(_Hand(), _OpponentsCount()) & " ["&_ActionsString()&"] [call="&$actionAmountToCall&"|raise="&$actionAmountToRaise&"]"
EndFunc
