#include-once
#include <WinAPI.au3>

; usage:
;#include "vendors/AutoItExt/GUICtrlGetBkColor.au3"
;_WinAPI_DrawRect($x, $y, $x + 99, $y + 99, 0x0000FF) ; makes 100x100

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