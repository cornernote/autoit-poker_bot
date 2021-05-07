#include-once

#include <ScreenCapture.au3>


Func _Screenshot()
   Local $date = (@YEAR & "-" & @MON & "-" & @MDAY & "-" & @HOUR & "-" & @MIN & "-" & @SEC & "-" & @MSEC)
   Local $path = @ScriptDir & "\data\screenshot"
   DirCreate($path)
   _ScreenCapture_Capture($path & "\" & $date & ".png", $window[0], $window[1], $window[0]+$window[2]-1, $window[1]+$window[3]-1, False)
EndFunc
