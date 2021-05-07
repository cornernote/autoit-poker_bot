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

; checks if it the bots turn to take an action
Func _PlayCanPlay()
   $playFailChecksumPlay = Null
   $playFailChecksumAllIn = -1
   $playFailChecksumRaise = -1
   $playFailChecksumCall = -1
   $playFailChecksumCheck = -1
   $playFailChecksumFold = -1
   Local $x = $windowPos[0]+Int(IniRead(@ScriptDir & "\settings.ini","play","active_x", 0)) ; x pos
   Local $y = $windowPos[1]+Int(IniRead(@ScriptDir & "\settings.ini","play","active_y", 0)) ; y pos
   Local $checksums = StringSplit(IniRead(@ScriptDir & "\settings.ini","play","active_checksums", ""), ",") ; pixel checksums
   Local $size = 2
   Local $currentChecksum = PixelChecksum($x-$size, $y-$size, $x+$size, $y+$size)
   For $i = 1 To $checksums[0]
	  Local $checksum = $checksums[$i]
	  If $currentChecksum = $checksum Then
		 Return True
	  EndIf
   Next
   $playFailChecksumPlay = $currentChecksum
EndFunc   ;==>_PlayCanPlay

; check if there is a button to go all in
Func _PlayCanAllIn()
   $playFailChecksumAllIn = Null
   Local $x = $windowPos[0]+Int(IniRead(@ScriptDir & "\settings.ini","play","all_in_x", 0)) ; x pos
   Local $y = $windowPos[1]+Int(IniRead(@ScriptDir & "\settings.ini","play","all_in_y", 0)) ; y pos
   Local $checksums = StringSplit(IniRead(@ScriptDir & "\settings.ini","play","all_in_checksums", ""), ",") ; pixel checksums
   Local $size = 2
   Local $currentChecksum = PixelChecksum($x-$size, $y-$size, $x+$size, $y+$size)
   For $i = 1 To $checksums[0]
	  Local $checksum = $checksums[$i]
	  If $currentChecksum = $checksum Then
		 Return True
	  EndIf
   Next
   $playFailChecksumAllIn = $currentChecksum
EndFunc   ;==>_PlayCanAllIn

; check if there is a button to raise
Func _PlayCanRaise()
   $playFailChecksumRaise = Null
   Local $x = $windowPos[0]+Int(IniRead(@ScriptDir & "\settings.ini","play","raise_x", 0)) ; x pos
   Local $y = $windowPos[1]+Int(IniRead(@ScriptDir & "\settings.ini","play","raise_y", 0)) ; y pos
   Local $checksums = StringSplit(IniRead(@ScriptDir & "\settings.ini","play","raise_checksums", ""), ",") ; pixel checksums
   Local $size = 2
   Local $currentChecksum = PixelChecksum($x-$size, $y-$size, $x+$size, $y+$size)
   For $i = 1 To $checksums[0]
	  Local $checksum = $checksums[$i]
	  If $currentChecksum = $checksum Then
		 Return True
	  EndIf
   Next
   $playFailChecksumRaise = $currentChecksum
EndFunc   ;==>_PlayCanRaise

; check if there is a button to call
Func _PlayCanCall()
   $playFailChecksumCall = Null
   Local $x = $windowPos[0]+Int(IniRead(@ScriptDir & "\settings.ini","play","call_x", 0)) ; x pos
   Local $y = $windowPos[1]+Int(IniRead(@ScriptDir & "\settings.ini","play","call_y", 0)) ; y pos
   Local $checksums = StringSplit(IniRead(@ScriptDir & "\settings.ini","play","call_checksums", ""), ",") ; pixel checksums
   Local $size = 2
   Local $currentChecksum = PixelChecksum($x-$size, $y-$size, $x+$size, $y+$size)
   For $i = 1 To $checksums[0]
	  Local $checksum = $checksums[$i]
	  If $currentChecksum = $checksum Then
		 Return True
	  EndIf
   Next
   $playFailChecksumCall = $currentChecksum
EndFunc   ;==>_PlayCanCall

; check if there is a button to check
Func _PlayCanCheck()
   $playFailChecksumCheck = Null
   Local $x = $windowPos[0]+Int(IniRead(@ScriptDir & "\settings.ini","play","check_x", 0)) ; x pos
   Local $y = $windowPos[1]+Int(IniRead(@ScriptDir & "\settings.ini","play","check_y", 0)) ; y pos
   Local $checksums = StringSplit(IniRead(@ScriptDir & "\settings.ini","play","check_checksums", ""), ",") ; pixel checksums
   Local $size = 2
   Local $currentChecksum = PixelChecksum($x-$size, $y-$size, $x+$size, $y+$size)
   For $i = 1 To $checksums[0]
	  Local $checksum = $checksums[$i]
	  If $currentChecksum = $checksum Then
		 Return True
	  EndIf
   Next
   $playFailChecksumCheck = $currentChecksum
EndFunc   ;==>_PlayCanCheck

; check if there is a button to fold
Func _PlayCanFold()
   $playFailChecksumFold = Null
   Local $x = $windowPos[0]+Int(IniRead(@ScriptDir & "\settings.ini","play","fold_x", 0)) ; x pos
   Local $y = $windowPos[1]+Int(IniRead(@ScriptDir & "\settings.ini","play","fold_y", 0)) ; y pos
   Local $checksums = StringSplit(IniRead(@ScriptDir & "\settings.ini","play","fold_checksums", ""), ",") ; pixel checksums
   Local $size = 2
   Local $currentChecksum = PixelChecksum($x-$size, $y-$size, $x+$size, $y+$size)
   For $i = 1 To $checksums[0]
	  Local $checksum = $checksums[$i]
	  If $currentChecksum = $checksum Then
		 Return True
	  EndIf
   Next
   $playFailChecksumFold = $currentChecksum
EndFunc   ;==>_PlayCanCheck

; play all in action
Func _PlayAllIn($log)
   ;_Log('_PlayAllIn')
   GUICtrlSetData($guiAction, 'all-in')
   If Not _PlayCanPlay() Then Return
   If _PlayCanAllIn() Then
	  _Log('_PlayAllIn = yes')
	  If $paused Then Return True
	  _PlayLog($log & '|action=all-in')
	  Local $x = $windowPos[0]+Int(IniRead(@ScriptDir & "\settings.ini","play","all_in_x", 0)) ; x pos
	  Local $y = $windowPos[1]+Int(IniRead(@ScriptDir & "\settings.ini","play","all_in_y", 0)) ; y pos
	  MouseClick($MOUSE_CLICK_LEFT, $x, $y, 1)
	  Sleep(500)
	  MouseMove($windowPos[0], $windowPos[1], 1)
	  _PlayRaise($log)
	  Return True
   EndIf
   _Log('_PlayAllIn = no')
   _PlayRaise($log)
EndFunc   ;==>_PlayAllIn

; play raise action
Func _PlayRaise($log, $amount = 0, $maximum = 'any')
   ;_Log('_PlayRaise: ' & $amount & '-' & $maximum)
   GUICtrlSetData($guiAction, 'raise')
   If Not _PlayCanPlay() Then Return
   If _PlayCanRaise() Then
	  Local $current = _AmountToRaise()
	  If Not IsString($maximum) And $current > $maximum Then
		 _Log('_PlayRaise = no: amount too high: ' & $current & '>' & $maximum)
		 _PlayCall($log & '|amount:'&$amount&'|maximum:'&$maximum&'|current:'&$current, $maximum)
		 Return
	  EndIf
	  _Log('_PlayRaise = yes')
	  If $paused Then Return True
	  _PlayLog($log & '|amount:'&$amount&'|maximum:'&$maximum&'|current:'&$current&'|action:raise')
      Local $x = $windowPos[0]+Int(IniRead(@ScriptDir & "\settings.ini","play","raise_x", 0)) ; x pos
      Local $y = $windowPos[1]+Int(IniRead(@ScriptDir & "\settings.ini","play","raise_y", 0)) ; y pos
	  ; TODO
	  If $amount Then
		 ; click the raise textbox
		 ; Send($amount)
	  EndIf
	  MouseClick($MOUSE_CLICK_LEFT, $x, $y, 1)
	  Sleep(500)
	  MouseMove($windowPos[0], $windowPos[1], 1)
	  Return True
   EndIf
   _Log('_PlayRaise = no')
   _PlayCall($log, $maximum)
EndFunc   ;==>_PlayRaise

; play call action
Func _PlayCall($log, $maximum = 'any')
   ;_Log('_PlayCall: ' & $amount)
   GUICtrlSetData($guiAction, 'call')
   If Not _PlayCanPlay() Then Return
   If _PlayCanCall() Then
      Local $x = $windowPos[0]+Int(IniRead(@ScriptDir & "\settings.ini","play","call_x", 0)) ; x pos
      Local $y = $windowPos[1]+Int(IniRead(@ScriptDir & "\settings.ini","play","call_y", 0)) ; y pos
	  Local $current = _AmountToCall()
	  If Not IsString($maximum) And $current > $maximum Then
		 _Log('_PlayCall = no: amount too high: ' & $current & '>' & $maximum)
		 _PlayCheck($log & '|maximum:'&$maximum&'|current:'&$current)
		 Return
	  EndIf
	  _Log('_PlayCall = yes: amount ok: ' & $current & '<=' & $maximum)
	  If $paused Then Return True
	  _PlayLog($log & '|maximum:'&$maximum&'|current:'&$current&'|action:call')
	  MouseClick($MOUSE_CLICK_LEFT, $x, $y, 1)
	  Sleep(500)
	  MouseMove($windowPos[0], $windowPos[1], 1)
	  Return True
   EndIf
   _Log('_PlayCall = no')
   _PlayCheck($log)
EndFunc   ;==>_PlayCall

; play check action
Func _PlayCheck($log)
   ;_Log('_PlayCheck')
   GUICtrlSetData($guiAction, 'check')
   If Not _PlayCanPlay() Then Return
   If _PlayCanCheck() Then
	  _Log('_PlayCheck = yes')
	  If $paused Then Return True
	  _PlayLog($log & '|action=check')
	  Local $x = $windowPos[0]+Int(IniRead(@ScriptDir & "\settings.ini","play","check_x", 0)) ; x pos
	  Local $y = $windowPos[1]+Int(IniRead(@ScriptDir & "\settings.ini","play","check_y", 0)) ; y pos
	  MouseClick($MOUSE_CLICK_LEFT, $x, $y, 1)
	  Sleep(500)
	  MouseMove($windowPos[0], $windowPos[1], 1)
	  Return True
   EndIf
   _Log('_PlayCheck = no')
   _PlayFold($log)
EndFunc   ;==>_PlayCheck

; play fold action
Func _PlayFold($log)
	;_Log('_PlayFold')
   GUICtrlSetData($guiAction, 'fold')
   If Not _PlayCanPlay() Then Return
   If _PlayCanFold() Then
	  _Log('_PlayFold = yes')
	  If $paused Then Return True
	  _PlayLog($log & '|action=fold')
      Local $x = $windowPos[0]+Int(IniRead(@ScriptDir & "\settings.ini","play","fold_x", 0)) ; x pos
      Local $y = $windowPos[1]+Int(IniRead(@ScriptDir & "\settings.ini","play","fold_y", 0)) ; y pos
	  MouseClick($MOUSE_CLICK_LEFT, $x, $y, 1)
	  Sleep(500)
	  MouseMove($windowPos[0], $windowPos[1], 1)
	  Return True
   EndIf
   _Log('_PlayFold = no')
EndFunc   ;==>_PlayFold

; logs a played action
Func _PlayLog($log)
   Local $date = (@YEAR & "-" & @MON & "-" & @MDAY & "-" & @HOUR & "-" & @MIN & "-" & @SEC & "-" & @MSEC)
   Local $path = @ScriptDir & "\data\action"
   DirCreate($path)
   _ScreenCapture_Capture($path & "\" & $date & ".png", $windowPos[0], $windowPos[1], $windowPos[0]+$windowPos[2]-1, $windowPos[1]+$windowPos[3]-1, False)
   FileWriteLine($path & "\" & (@YEAR & "-" & @MON & "-" & @MDAY) & ".txt", $date&': '&$log)
EndFunc   ;==>_PlayLog

