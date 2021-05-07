#include-once

#include <Array.au3>

Func _LogInit()
   Local $path = @ScriptDir & "\data\log"
   DirCreate($path)
EndFunc

Func _Log($value)
   Local $path = @ScriptDir & "\data\log"
   Local $date = (@YEAR & "-" & @MON & "-" & @MDAY & "-" & @HOUR & "-" & @MIN & "-" & @SEC & "-" & @MSEC)
   $filename = $path&'\'&(@YEAR & "-" & @MON & "-" & @MDAY)&'.txt'
   If IsArray($value) Then
	  $value = _ArrayToString($value)
   EndIf
   Local $log = $date&': '&$value&@CRLF
   FileWriteLine($filename,$log)
   ConsoleWrite($log)
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
