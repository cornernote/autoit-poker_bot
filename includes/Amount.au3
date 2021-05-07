#include-once

Func _AmountToCall()
   Local $x = $windowPos[0]+Int(IniRead(@ScriptDir & "\settings.ini","amount","call_amount_x", 0))
   Local $y = $windowPos[1]+Int(IniRead(@ScriptDir & "\settings.ini","amount","call_amount_y", 0))
   Local $checksum = PixelChecksum($x, $y, $x + 130, $y + 35)
   Local $path = @ScriptDir & "\data\ocr"
   _ScreenCapture_Capture($path & "\" & $checksum & ".png", $x, $y, $x + 130, $y + 35, False)
   Local $amount = _Ocr($checksum & ".png")
   _Log('_AmountToCall: '&$amount)
   Return _AmountToInt($amount)
EndFunc   ;==>_AmountToCall

Func _AmountToRaise()
   Local $x = $windowPos[0]+Int(IniRead(@ScriptDir & "\settings.ini","amount","raise_amount_x", 0))
   Local $y = $windowPos[1]+Int(IniRead(@ScriptDir & "\settings.ini","amount","raise_amount_y", 0))
   Local $path = @ScriptDir & "\data\ocr"
   Local $checksum = PixelChecksum($x, $y, $x + 130, $y + 35)
   _ScreenCapture_Capture($path & "\" & $checksum & ".png", $x, $y, $x + 130, $y + 35, False)
   Local $amount = _Ocr($checksum & ".png")
   _Log('_AmountToRaise: '&$amount)
   Return _AmountToInt($amount)
EndFunc   ;==>_AmountToRaise

Func _AmountToInt($amount)
   Local $default = 1000*1000*1000*1000 ; big number
   If StringInStr($amount, "K") Or StringInStr($amount, "M") Or StringInStr($amount, "B") Then
	  Local $ext = StringMid($amount, StringLen($amount), 1)
	  $amount = StringReplace($amount, $ext, "")
	  Switch $ext
		 Case 'K'
			$amount = $amount*1000
		 Case 'M'
			$amount = $amount*1000*1000
		 Case 'B'
			$amount = $amount*1000*1000*1000
	  EndSwitch
   EndIf
   If IsString($amount) Then
	  If StringIsDigit($amount) Then
		 $amount = Int($amount)
	  Else
		 Return $default
	  EndIf
   EndIf
   If $amount Then
	  Return $amount
   EndIf
   Return $default
EndFunc
