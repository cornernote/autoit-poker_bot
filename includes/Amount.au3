#include-once

; convert amount (eg 17.5k) to number
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