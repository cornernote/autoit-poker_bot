;=================================================================
; Botage Poker Bot
; Copyright © 2009 Brett O'Donnell
;=================================================================
;
; This file is part of Botage Poker Bot.
;
; Botage Poker Bot is free software: you can redistribute it
; and/or modify it under the terms of the GNU General Public
; License as published by the Free Software Foundation,
; either version 3 of the License, or (at your option) any
; later version.
;
; Botage Poker Bot is distributed in the hope that it will
; be useful, but WITHOUT ANY WARRANTY; without even the
; implied warranty of MERCHANTABILITY or FITNESS FOR A
; PARTICULAR PURPOSE.  See the GNU General Public License
; for more details.
;
; You should have received a copy of the GNU General Public
; License along with Botage Poker Bot.  If not, see
; <http://www.gnu.org/licenses/>.
;
; This program is distributed under the terms of the GNU
; General Public License.
;
;=================================================================

;=================================================================
; Play Turn Functions
;=================================================================
#include-once
#include <Array.au3>
#include "vendor/ScreenCapture/ScreenCaptureFixed.au3"
#include "Table.au3"
#include "OCR.au3"

Global $sPlayTurn
Global $oPlayTurnDictionary = ObjCreate("Scripting.Dictionary")
Global $sDataPath = '..\data'

Func _PlayTurnRaise($amount, $maximum)
	_Log('_PlayTurnRaise: ' & $amount & '-' & $maximum)
	$sPlayTurn = $sPlayTurn & @CRLF & '_PlayTurnRaise: ' & $amount & '-' & $maximum
	If _MyTurn() Then
		$checksum = PixelChecksum($aTop[0] + 267, $aTop[1] + 411, $aTop[0] + 277, $aTop[1] + 421)
		$sReraise = True ;reraise fix
		If _PlayTurnChecksum('raise', $checksum) Then
			$current = _GetRaiseAmount()
			;If $current<$amount Then
			_Log('_PlayTurnRaise = yes: ' & $checksum)
			Send($amount)
			Sleep(500)
			MouseClick('left', $aTop[0] + 267, $aTop[1] + 411, 1, 0)
			Sleep(500)
			MouseMove($aTop[0], $aTop[1], 0)
			Return True
			;EndIf
			;MouseMove($aTop[0],$aTop[1],0)
		Else
			_Log('_PlayTurnRaise = no: ' & $checksum)
		EndIf
		_PlayTurnCall($maximum)
		Return False
	EndIf
EndFunc   ;==>_PlayTurnRaise



Func _PlayTurnCall($amount)
	$sPlayTurn = $sPlayTurn & @CRLF & '_PlayTurnCall: ' & $amount
	_Log('_PlayTurnCall: ' & $amount)
	If _MyTurn() Then
		$samount_call = True
		$checksum = PixelChecksum($aTop[0] + 290, $aTop[1] + 370, $aTop[0] + 300, $aTop[1] + 380)
		If _PlayTurnChecksum('call', $checksum) Then
			_Log('_PlayTurnCall = yes: ' & $checksum)
			If $amount <> 'any' Then
				$callamount = _GetCallAmount()
			Else
				$callamount = 0
			EndIf
			If @error == 0 And $amount >= $callamount Then
				;_Log('called')
				Sleep(500)
				MouseClick('left', $aTop[0] + 290, $aTop[1] + 370, 1, 0)
				Sleep(500)
				MouseMove($aTop[0], $aTop[1], 0)
				Return True
			EndIf
		Else
			_Log('_PlayTurnCall = no: ' & $checksum)
			_PlayTurnCheck(False)
			Return False
		EndIf
		_PlayTurnCheck(False)
		Return False
	EndIf
EndFunc   ;==>_PlayTurnCall

Func _PlayFredTurnCall($camount)
	If _MyTurn() Then
		$checksum = PixelChecksum($aTop[0] + 290, $aTop[1] + 370, $aTop[0] + 300, $aTop[1] + 380)
		If _PlayTurnChecksum('call', $checksum) Then
			_Log('_PlayFredTurnCall = yes: ' & $checksum)
		EndIf
		
		If $camount > 0 Then
			;$amount = _GetFredCallAmount()
			$amount=_rageRaise()
			;Ignore no box on screen
			If $amount="" Then
				$amount=0
				;Ignore Can't run Tesseract
			ElseIf $amount="-1" Then
				$amount=0					
			Else
				$amount=Round((Int($amount)) / 2)
			EndIf
		Else
			$amount = 0
		EndIf
		
		If $amount >= $iBlind Then
			$samount = $samount + $amount
		EndIf
		
		If $samount > $camount Then
			;$iCall = True
			$samount = 0 
			$amount = 0 
		EndIf
		
		If Int($amount) <> 0 Then
			If Int($amount) <= Int($camount) Then
				_Log('deadeyecalled')
				Sleep(500)
				MouseClick('left', $aTop[0] + 290, $aTop[1] + 370, 1, 0)
				Sleep(700)
				MouseMove($aTop[0], $aTop[1], 0)

				Return True
			Else
				_PlayTurnCheck(True)
				Return False
			EndIf
		ElseIf Int($amount) = 0 Then
			_PlayTurnCheck()
			Return False
		EndIf
		_PlayTurnCheck(False)
		Return False
	EndIf
EndFunc   ;==>_PlayFredTurnCall

Func _PlayFredTurnCall2($camount)
	If _MyTurn() Then
		$checksum = PixelChecksum($aTop[0] + 290, $aTop[1] + 370, $aTop[0] + 300, $aTop[1] + 380)
		If _PlayTurnChecksum('call', $checksum) Then
			_Log('_PlayFredTurnCall = yes: ' & $checksum)
		EndIf
				
		If $camount > 0 Then
			;$amount = _GetFredCallAmount()
			$amount=_rageRaise()
			;Ignore no box on screen
			If $amount="" Then
				$amount=0
				;Ignore Can't run Tesseract
			ElseIf $amount="-1" Then
				$amount=0					
			Else
				$amount=Round((Int($amount)) / 2)
			EndIf
		Else
			$amount = 0
		EndIf
		
		If $amount >= $iBlind Then
			$damount = $damount + $amount
		EndIf
		
		If $damount > $camount Then
			;$uCall = True
			$damount = 0
			$amount = 0
		EndIf
		
		If Int($amount) <> 0 Then
			If Int($amount) <= Int($camount) Then
				_Log('deadeyecalled')
				Sleep(500)
				MouseClick('left', $aTop[0] + 290, $aTop[1] + 370, 1, 0)
				Sleep(700)
				MouseMove($aTop[0], $aTop[1], 0)
				Return True
			Else
				_PlayTurnCheck(True)
				Return False
			EndIf
		ElseIf Int($amount) = 0 Then
			_PlayTurnCheck()
			Return False
		EndIf
		_PlayTurnCheck(False)
		Return False
	EndIf
EndFunc   ;==>_PlayFredTurnCall

Func _PlayFredTurnCall3($camount)
	If _MyTurn() Then
		$checksum = PixelChecksum($aTop[0] + 290, $aTop[1] + 370, $aTop[0] + 300, $aTop[1] + 380)
		If _PlayTurnChecksum('call', $checksum) Then
			_Log('_PlayFredTurnCall = yes: ' & $checksum)
		EndIf
				
		If $camount > 0 Then
			;$amount = _GetFredCallAmount()
			$amount=_rageRaise()
			;Ignore no box on screen
			If $amount="" Then
				$amount=0
				;Ignore Can't run Tesseract
			ElseIf $amount="-1" Then
				$amount=0					
			Else
				$amount=Round((Int($amount)) / 2)
			EndIf
		Else
			$amount = 0
		EndIf
		
		If $amount >= $iBlind Then
			$eamount = $eamount + $amount
		EndIf
		
		If $eamount > $camount Then
			;$uCall = True
			$eamount = 0
			$amount = 0
		EndIf
		
		If Int($amount) <> 0 Then
			If Int($amount) <= Int($camount) Then
				_Log('deadeyecalled')
				Sleep(500)
				MouseClick('left', $aTop[0] + 290, $aTop[1] + 370, 1, 0)
				Sleep(700)
				MouseMove($aTop[0], $aTop[1], 0)
				Return True
			Else
				_PlayTurnCheck(True)
				Return False
			EndIf
		ElseIf Int($amount) = 0 Then
			_PlayTurnCheck()
			Return False
		EndIf
		_PlayTurnCheck(False)
		Return False
	EndIf
EndFunc   ;==>_PlayFredTurnCall

Func _PlayFredTurnCall4($camount)
	If _MyTurn() Then
		$checksum = PixelChecksum($aTop[0] + 290, $aTop[1] + 370, $aTop[0] + 300, $aTop[1] + 380)
		If _PlayTurnChecksum('call', $checksum) Then
			_Log('_PlayFredTurnCall = yes: ' & $checksum)
		EndIf
				
		If $camount > 0 Then
			;$amount = _GetFredCallAmount()
			$amount=_rageRaise()
			;Ignore no box on screen
			If $amount="" Then
				$amount=0
				;Ignore Can't run Tesseract
			ElseIf $amount="-1" Then
				$amount=0					
			Else
				$amount=Round((Int($amount)) / 2)
			EndIf
		Else
			$amount = 0
		EndIf
		
		If $amount >= $iBlind Then
			$famount = $famount + $amount
		EndIf
		
		If $famount > $camount Then
			;$uCall = True
			$famount = 0
			$amount = 0
		EndIf
		
		If Int($amount) <> 0 Then
			If Int($amount) <= Int($camount) Then
				_Log('deadeyecalled')
				Sleep(500)
				MouseClick('left', $aTop[0] + 290, $aTop[1] + 370, 1, 0)
				Sleep(700)
				MouseMove($aTop[0], $aTop[1], 0)
				Return True
			Else
				_PlayTurnCheck(True)
				Return False
			EndIf
		ElseIf Int($amount) = 0 Then
			_PlayTurnCheck()
			Return False
		EndIf
		_PlayTurnCheck(False)
		Return False
	EndIf
EndFunc   ;==>_PlayFredTurnCall

Func _GetCallAmount()
	$checksum = PixelChecksum($aTop[0] + 318, $aTop[1] + 373, $aTop[0] + 373, $aTop[1] + 386)
	$filename = $sDataPath & '\call\' & $checksum
	$amount = FileRead($filename & '.txt')
	If @error == 0 Then
		Return $amount
	EndIf

	_ScreenCapture_Capture($filename & '.tif', $aTop[0] + 318, $aTop[1] + 373, $aTop[0] + 373, $aTop[1] + 386, False)
	ShellExecuteWait("convert.exe", '"' & $filename & '.tif" -resize 200% -bordercolor white -border 150x150 "' & $filename & '-border.tif"', "C:\Program Files\ImageMagick-6.5.0-Q16\", "", 0)
	Sleep(500)
	If Not FileExists($filename & "-border.tif") Then
		Return False
	EndIf
	$sArray = OCRGet($filename & "-border.tif")
	If @error <> 0 Then
		SetError(1)
		Return False
	EndIf
	$amount = _ArrayToString($sArray, "")
	$amount = StringRight($amount, StringLen($amount) - 1)
	If StringLeft($amount, 1) == '$' Or StringLeft($amount, 1) == 5 Or StringLeft($amount, 1) == 'S' Or StringLeft($amount, 1) == 's' Then
		$amount = StringRight($amount, StringLen($amount) - 1)
	EndIf
	$amount = StringReplace($amount, ',', '') ; remove commas
	$amount = StringReplace($amount, '.', '') ; remove commas
	$amount = StringReplace($amount, 'A', '') ; ocr thinks comma is A
	$amount = StringReplace($amount, 'L', '') ; ocr thinks comma is L
	FileWrite($filename & '.txt', $amount)
	FileDelete($filename & "-border.tif")
	Return $amount
EndFunc   ;==>_GetCallAmount

Func _GetRaiseAmount($iLoop = 0)
	If $iLoop > 2 Then
		Return 0
	EndIf
	ClipPut('-')
	MouseClick('left', $aTop[0] + 450, $aTop[1] + 417, 1, 0)
	Sleep(200)
	Send("^a")
	Sleep(200)
	Send("^c")
	Sleep(200)
	$amount = ClipGet()
	If $amount == '-' Then
		$amount = _GetRaiseAmount($iLoop + 1)
	EndIf
	Return $amount
EndFunc   ;==>_GetRaiseAmount10

Func _GetFredCallAmount()
	ClipPut("")
	MouseClick('left', $aTop[0] + 540, $aTop[1] + 370, 1, 0)
	Sleep(300)
	Send("^a")
	Sleep(300)
	Send("{DEL 1}")
	Sleep(50)
	MouseClick('left', $aTop[0] + 495, $aTop[1] + 417, 1, 0)
	Sleep(700)
	MouseClick("left")
	Sleep(10)
	MouseClick("left")
	Sleep(700)
	Send("^c")
	Sleep(100)
	MouseClick("left")
	Sleep(100)
	$amount = Int(ClipGet())
	If $amount <> "" Then
		Return Round($amount / 2)
	Else
		Return 0
	EndIf
EndFunc   ;==>_GetRaiseAmount


Func _PlayTurnCheck($bAllowFold = True)
	$sPlayTurn = $sPlayTurn & @CRLF & '_PlayTurnCheck'
	_Log('_PlayTurnCheck')
	If _MyTurn() Then
		$iCall = False
		$damount = 0
		$samount = 0
		$checksum = PixelChecksum($aTop[0] + 290, $aTop[1] + 375, $aTop[0] + 300, $aTop[1] + 385)
		;MouseClickDrag('left',$aTop[0]+290,$aTop[1]+375,$aTop[0]+300,$aTop[1]+385)
		If Not $bAllowFold Or _PlayTurnChecksum('check', $checksum) Then
			_Log('_PlayTurnCheck = yes: ' & $checksum)
			Sleep(500)
			MouseClick('left', $aTop[0] + 290, $aTop[1] + 375, 1, 0)
			Sleep(500)
			MouseMove($aTop[0], $aTop[1], 0)
			Return True
		Else
			_Log('_PlayTurnCheck = no: ' & $checksum)
			_PlayTurnFold()
			Return False
		EndIf
		_PlayTurnFold()
		Return False
	EndIf
EndFunc   ;==>_PlayTurnCheck

Func _PlayTurnFold()
	_Log('_PlayTurnFold')
	$sPlayTurn = $sPlayTurn & @CRLF & '_PlayTurnFold'
	If _MyTurn() Then
		_Log('_PlayTurnFold = yes')
		Sleep(500)
		MouseClick('left', $aTop[0] + 390, $aTop[1] + 370, 1, 0)
		Sleep(500)
		MouseMove($aTop[0], $aTop[1], 0)
		Return True
	EndIf
	Return False
EndFunc   ;==>_PlayTurnFold

Func _MyTurn()
	_Log('_MyTurn')
	$checksum = PixelChecksum($aTop[0] + 390, $aTop[1] + 375, $aTop[0] + 400, $aTop[1] + 385)
	If _PlayTurnChecksum('fold', $checksum) Then
		_Log('_MyTurn = yes: ' & $checksum)
		Return True
	Else
		_Log('_MyTurn = no: ' & $checksum)
	EndIf
	Return False
EndFunc   ;==>_MyTurn

Func _PlayTurnChecksum($sType, $iChecksum)
	If IsObj($oPlayTurnDictionary) And $oPlayTurnDictionary.Exists($sType & $iChecksum) Then
		Return Int($oPlayTurnDictionary.Item($sType & $iChecksum))
	EndIf
	If IniRead($sDataPath & "\playturn.ini", "PlayTurn", $iChecksum, 'none') == $sType Then
		If IsObj($oPlayTurnDictionary) Then
			$oPlayTurnDictionary.Add($sType & $iChecksum, 1)
		EndIf
		Return True
	Else
		If IsObj($oPlayTurnDictionary) Then
			$oPlayTurnDictionary.Add($sType & $iChecksum, 0)
		EndIf
		Return False
	EndIf
EndFunc   ;==>_PlayTurnChecksum
