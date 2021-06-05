;=================================================================
; Read the Action Buttons
;=================================================================
#include-once

#include <Array.au3>

; stores the read cards
Global $actions[5]

; define number and suit checksum maps
Const $ACTION_FOLD = 0
Const $ACTION_CHECK = 1
Const $ACTION_CALL = 2
Const $ACTION_RAISE = 3
Const $ACTION_ALL_IN = 4
Global $actionCodes[5] = ["fold","check","call","raise","all_in"]

; used to get checksum if the match fails
Global $actionFailChecksum[5]

; call and raise amounts
Global $actionAmountToCall
Global $actionAmountToRaise

; reset cards array
Func _ActionsReset()
   $actionAmountToCall = False
   $actionAmountToRaise = False
   Local $_actions[UBound($actions)]
   $actions = $_actions
   Local $_actionFailChecksum[UBound($actionFailChecksum)]
   $actionFailChecksum = $_actionFailChecksum
EndFunc

; read action buttons
Func _ActionsRead()
   _ActionsReset()
   For $i = 0 To UBound($actions) - 1
	  $actions[$i] = _ActionRead($i)
	  If $i==$ACTION_FOLD And Not $actions[$i] Then
		 ExitLoop
	  EndIf
	  If $i==$ACTION_CALL And $actions[$i] Then
		 $actionAmountToCall = _ActionReadAmount('call')
	  EndIf
	  If $i==$ACTION_RAISE And $actions[$i] Then
		 $actionAmountToRaise = _ActionReadAmount('raise')
	  EndIf
   Next
EndFunc

; read action buttons
Func _ActionRead($actionIndex)
   $actionFailChecksum[$actionIndex] = False
   Local $code = $actionCodes[$actionIndex]
   Local $x = $window[0]+Eval("ini_action_"&$code&"_x")
   Local $y = $window[1]+Eval("ini_action_"&$code&"_y")
   Local $checksums = StringSplit(Eval("ini_action_"&$code&"_checksums"), ",")
   Local $size = 2
   Local $currentChecksum = PixelChecksum($x-$size, $y-$size, $x+$size, $y+$size)
   For $i = 1 To $checksums[0]
	  Local $checksum = $checksums[$i]
	  If $currentChecksum = $checksum Then
		 Return True
	  EndIf
   Next
   $actionFailChecksum[$actionIndex] = $currentChecksum
EndFunc

; read amount
Func _ActionReadAmount($type)
   Local $x = $window[0]+Eval("ini_amount_"&$type&"_x")
   Local $y = $window[1]+Eval("ini_amount_"&$type&"_y")
   Local $w = Eval("ini_amount_"&$type&"_w")
   Local $h = Eval("ini_amount_"&$type&"_h")
   Local $path = @ScriptDir & "\data\ocr"
   Local $checksum = PixelChecksum($x, $y, $x + $w, $y + $h)
   If Not FileExists($path & "\" & $checksum & ".png") Then
	  _ScreenCapture_Capture($path & "\" & $checksum & ".png", $x, $y, $x + $w, $y + $h, False)
   EndIf
   Local $amount = _Ocr($checksum & ".png")
   ;_Log('_ActionReadAmount: '&$amount)
   Return $amount
EndFunc

; get a string of the actions
Func _ActionsString()
   Local $string
   For $i = 0 To UBound($actions) - 1
	  If $actions[$i] Then
		 $string = $string & $actionCodes[$i]
	  Else
		 $string = $string & "-"
	  EndIf
	  $string = $string & " "
   Next
   $string = StringStripWS($string, $STR_STRIPTRAILING)
   Return $string
EndFunc