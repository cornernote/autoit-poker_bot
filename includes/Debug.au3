
#include-once

#include <Array.au3>
#include <WinAPI.au3>


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



Func _DrawRect($start_x, $start_y, $iWidth, $iHeight, $iColor)
    Local $hDC = _WinAPI_GetWindowDC(0) ; DC of entire screen (desktop)
    Local $tRect = DllStructCreate($tagRECT)
    DllStructSetData($tRect, 1, $start_x)
    DllStructSetData($tRect, 2, $start_y)
    DllStructSetData($tRect, 3, $iWidth)
    DllStructSetData($tRect, 4, $iHeight)
    Local $hBrush = _WinAPI_CreateSolidBrush($iColor)

    _WinAPI_FrameRect($hDC, DllStructGetPtr($tRect), $hBrush)

    ; clear resources
    _WinAPI_DeleteObject($hBrush)
    _WinAPI_ReleaseDC(0, $hDC)
EndFunc   ;==>_WinAPI_DrawRect