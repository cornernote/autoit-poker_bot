#include-once
#include <WinAPIGdi.au3>

; #FUNCTION# ====================================================================================================================
; Name ..........: GUICtrlGetBkColor
; Description ...: Retrieves the RGB value of the control background.
; Syntax ........: GUICtrlGetBkColor($hWnd)
; Parameters ....: $hWnd                - Control ID/Handle to the control
; Return values .: Success - RGB value
;                  Failure - 0
; Author ........: guinness
; Example .......: Yes
; See............: https://www.autoitscript.com/forum/topic/125684-guictrlgetbkcolor-get-the-background-color-of-a-control/
; ===============================================================================================================================

Func GUICtrlGetBkColor($hWnd)
    If Not IsHWnd($hWnd) Then
        $hWnd = GUICtrlGetHandle($hWnd)
    EndIf
    Local $hDC = _WinAPI_GetDC($hWnd)
    Local $iColor = _WinAPI_GetPixel($hDC, 3, 3)
    _WinAPI_ReleaseDC($hWnd, $hDC)
    Return $iColor
EndFunc   ;==>GUICtrlGetBkColor