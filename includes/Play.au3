#include-once
#include <Array.au3>
#include <ScreenCapture.au3>


; play the action selected by the profile
Func _PlayProfileAction()
   Local $hand = _Hand()
   ; do nothing if the hand was not fully read
   If Not $hand Then Return
   If StringInStr($hand,'-') Then Return
   ; play the selected action
   Switch $profilePlayAction
	  Case 'fold'
		 _PlayFold()
	  Case 'check'
		 _PlayCheck()
	  Case 'call'
		 _PlayCall($profilePlayMaximumCallAmount)
	  Case 'raise'
		 _PlayRaise($profilePlayRaiseAmount, $profilePlayMaximumCallAmount)
	  Case 'all_in'
		 _PlayAllIn()
   EndSwitch
EndFunc

; play all in action
Func _PlayAllIn()
   ;_Log('_PlayAllIn')
   If Not $actions[$ACTION_FOLD] Then Return
   If $actions[$ACTION_ALL_IN] Then
	  _Log('_PlayAllIn = yes')
	  If $paused Then Return True
	  _LogPlay('action=all_in')
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
EndFunc

; play raise action
Func _PlayRaise($amount = 0, $maximum = 'any')
   ;_Log('_PlayRaise: ' & $amount & '-' & $maximum)
   If Not $actions[$ACTION_FOLD] Then Return
   If $actions[$ACTION_RAISE] Then
	  If Not IsString($maximum) And _AmountToInt($actionAmountToRaise) > $maximum Then
		 _Log('_PlayRaise = no: amount too high: ' & $actionAmountToRaise & '>' & $maximum)
		 _PlayCall('amount:'&$amount&'|maximum:'&$maximum&'|current:'&$actionAmountToRaise, $maximum)
		 Return
	  EndIf
	  _Log('_PlayRaise = yes')
	  If $paused Then Return True
	  __LogPlay('amount:'&$amount&'|maximum:'&$maximum&'|action:raise')
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
EndFunc

; play call action
Func _PlayCall($maximum = 'any')
   ;_Log('_PlayCall: ' & $amount)
   If Not $actions[$ACTION_FOLD] Then Return
   If $actions[$ACTION_CALL] Then
      Local $x = $window[0]+$ini_action_call_x
      Local $y = $window[1]+$ini_action_call_y
	  If Not IsString($maximum) And _AmountToInt($actionAmountToCall) > $maximum Then
		 _Log('_PlayCall = no: amount too high: ' & $actionAmountToCall & '>' & $maximum)
		 _PlayCheck()
		 Return
	  EndIf
	  _Log('_PlayCall = yes: amount ok: ' & $actionAmountToCall & '<=' & $maximum)
	  If $paused Then Return True
	  _LogPlay('maximum:'&$maximum&'|action:call')
	  MouseClick($MOUSE_CLICK_LEFT, $x, $y, 1)
	  Sleep(500)
	  MouseMove($window[0], $window[1], 1)
	  Return True
   EndIf
   _Log('_PlayCall = no')
   _PlayCheck()
EndFunc

; play check action
Func _PlayCheck()
   ;_Log('_PlayCheck')
   If Not $actions[$ACTION_FOLD] Then Return
   If $actions[$ACTION_CHECK] Then
	  _Log('_PlayCheck = yes')
	  If $paused Then Return True
	  _LogPlay('action=check')
	  Local $x = $window[0]+$ini_action_check_x
	  Local $y = $window[1]+$ini_action_check_y
	  MouseClick($MOUSE_CLICK_LEFT, $x, $y, 1)
	  Sleep(500)
	  MouseMove($window[0], $window[1], 1)
	  Return True
   EndIf
   _Log('_PlayCheck = no')
   _PlayFold()
EndFunc

; play fold action
Func _PlayFold()
	;_Log('_PlayFold')
   If $actions[$ACTION_FOLD] Then
	  _Log('_PlayFold = yes')
	  If $paused Then Return True
	  _LogPlay('action=fold')
      Local $x = $window[0]+$ini_action_fold_x
      Local $y = $window[1]+$ini_action_fold_y
	  MouseClick($MOUSE_CLICK_LEFT, $x, $y, 1)
	  Sleep(500)
	  MouseMove($window[0], $window[1], 1)
	  Return True
   EndIf
   _Log('_PlayFold = no')
EndFunc

