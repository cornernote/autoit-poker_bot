#include-once
#include <Array.au3>
#include <ScreenCapture.au3>

; used to get checksum if the match fails
Global $playFailChecksumPlay
Global $playFailChecksumAllIn
Global $playFailChecksumRaise
Global $playFailChecksumCall
Global $playFailChecksumCheck
Global $playFailChecksumFold

; play all in action
Func _PlayAllIn()
   ;_Log('_PlayAllIn')
   GUICtrlSetData($guiPlay, 'all-in')
   If Not $actions[$ACTION_FOLD] Then Return
   If $actions[$ACTION_ALL_IN] Then
	  _Log('_PlayAllIn = yes')
	  If $paused Then Return True
	  _PlayLog('action=all-in')
	  Local $x = $window[0]+$ini_action_all_in_x
	  Local $y = $window[1]+$ini_action_all_in_y
	  MouseClick($MOUSE_CLICK_LEFT, $x, $y, 1)
	  Sleep(500)
	  MouseMove($window[0], $window[1], 1)
	  _PlayRaise()
	  Return True
   EndIf
   _Log('_PlayAllIn = no')
   _PlayRaise()
EndFunc   ;==>_PlayAllIn

; play raise action
Func _PlayRaise($amount = 0, $maximum = 'any')
   ;_Log('_PlayRaise: ' & $amount & '-' & $maximum)
   GUICtrlSetData($guiPlay, 'raise')
   If Not $actions[$ACTION_FOLD] Then Return
   If $actions[$ACTION_RAISE] Then
	  Local $current = _AmountToRaise()
	  If Not IsString($maximum) And $current > $maximum Then
		 _Log('_PlayRaise = no: amount too high: ' & $current & '>' & $maximum)
		 _PlayCall('amount:'&$amount&'|maximum:'&$maximum&'|current:'&$current, $maximum)
		 Return
	  EndIf
	  _Log('_PlayRaise = yes')
	  If $paused Then Return True
	  _PlayLog('amount:'&$amount&'|maximum:'&$maximum&'|current:'&$current&'|action:raise')
      Local $x = $window[0]+$ini_action_raise_x
      Local $y = $window[1]+$ini_action_raise_y
	  ; TODO
	  If $amount Then
		 ; click the raise textbox
		 ; Send($amount)
	  EndIf
	  MouseClick($MOUSE_CLICK_LEFT, $x, $y, 1)
	  Sleep(500)
	  MouseMove($window[0], $window[1], 1)
	  Return True
   EndIf
   _Log('_PlayRaise = no')
   _PlayCall($maximum)
EndFunc   ;==>_PlayRaise

; play call action
Func _PlayCall($maximum = 'any')
   ;_Log('_PlayCall: ' & $amount)
   GUICtrlSetData($guiPlay, 'call')
   If Not $actions[$ACTION_FOLD] Then Return
   If $actions[$ACTION_CALL] Then
      Local $x = $window[0]+$ini_action_call_x
      Local $y = $window[1]+$ini_action_call_y
	  Local $current = _AmountToCall()
	  If Not IsString($maximum) And $current > $maximum Then
		 _Log('_PlayCall = no: amount too high: ' & $current & '>' & $maximum)
		 _PlayCheck('maximum:'&$maximum&'|current:'&$current)
		 Return
	  EndIf
	  _Log('_PlayCall = yes: amount ok: ' & $current & '<=' & $maximum)
	  If $paused Then Return True
	  _PlayLog('maximum:'&$maximum&'|current:'&$current&'|action:call')
	  MouseClick($MOUSE_CLICK_LEFT, $x, $y, 1)
	  Sleep(500)
	  MouseMove($window[0], $window[1], 1)
	  Return True
   EndIf
   _Log('_PlayCall = no')
   _PlayCheck()
EndFunc   ;==>_PlayCall

; play check action
Func _PlayCheck()
   ;_Log('_PlayCheck')
   GUICtrlSetData($guiPlay, 'check')
   If Not $actions[$ACTION_FOLD] Then Return
   If $actions[$ACTION_CHECK] Then
	  _Log('_PlayCheck = yes')
	  If $paused Then Return True
	  _PlayLog('action=check')
	  Local $x = $window[0]+$ini_action_check_x
	  Local $y = $window[1]+$ini_action_check_y
	  MouseClick($MOUSE_CLICK_LEFT, $x, $y, 1)
	  Sleep(500)
	  MouseMove($window[0], $window[1], 1)
	  Return True
   EndIf
   _Log('_PlayCheck = no')
   _PlayFold()
EndFunc   ;==>_PlayCheck

; play fold action
Func _PlayFold()
	;_Log('_PlayFold')
   GUICtrlSetData($guiPlay, 'fold')
   If $actions[$ACTION_FOLD] Then
	  _Log('_PlayFold = yes')
	  If $paused Then Return True
	  _PlayLog('action=fold')
      Local $x = $window[0]+$ini_action_fold_x
      Local $y = $window[1]+$ini_action_fold_y
	  MouseClick($MOUSE_CLICK_LEFT, $x, $y, 1)
	  Sleep(500)
	  MouseMove($window[0], $window[1], 1)
	  Return True
   EndIf
   _Log('_PlayFold = no')
EndFunc   ;==>_PlayFold

; logs a played action
Func _PlayLog($log)
   Local $date = (@YEAR & "-" & @MON & "-" & @MDAY & "-" & @HOUR & "-" & @MIN & "-" & @SEC & "-" & @MSEC)
   Local $path = @ScriptDir & "\data\action"
   DirCreate($path)
   _ScreenCapture_Capture($path & "\" & $date & ".png", $window[0], $window[1], $window[0]+$window[2]-1, $window[1]+$window[3]-1, False)
   FileWriteLine($path & "\" & (@YEAR & "-" & @MON & "-" & @MDAY) & ".txt", $date&': '&$log)
EndFunc   ;==>_PlayLog

