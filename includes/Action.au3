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
; Opponent Action Functions
;=================================================================
#include-once
#Include "vendor/ScreenCapture/ScreenCaptureFixed.au3"
#Include "Table.au3"
#Include "Debug.au3"

Global $oActionDictionary = ObjCreate("Scripting.Dictionary")
Global $logScreenAction = 1
Global $sDataPath = '..\data'
Global $sLogPath = '..\log'
Global $aTop[2]

Func _Action()
	Return _ActionString(_ActionCount())
EndFunc

Func _ActionCount()
	Local $aActions[6] = [0,0,0,0,0,0] ; all in/raise/call/check/fold/winner
	For $i = 1 To 9
		$sAction = _ActionCheck($i)
		If $sAction=='all in' Then
			$aActions[0] = $aActions[0]+1
		ElseIf $sAction=='raise' Then
			$aActions[1] = $aActions[1]+1
		ElseIf $sAction=='call' Then
			$aActions[2] = $aActions[2]+1
		ElseIf $sAction=='call_any' Then
			$aActions[2] = $aActions[2]+1
		ElseIf $sAction=='call_once' Then
			$aActions[2] = $aActions[2]+1
		ElseIf $sAction=='call_upto' Then
			$aActions[2] = $aActions[2]+1
		ElseIf $sAction=='check' Then
			$aActions[3] = $aActions[3]+1
		ElseIf $sAction=='fold' Then
			$aActions[4] = $aActions[4]+1
		ElseIf $sAction=='winner' Then
			$aActions[5] = $aActions[5]+1
		EndIf
	Next
	Return $aActions
EndFunc

Func _ActionString($aActions)
	Local $sActions
	If $aActions[0] Then
		$sActions = $sActions & 'all in ' & $aActions[0] & ' | '
	EndIf
	If $aActions[1] Then
		$sActions = $sActions & 'raise ' & $aActions[1] & ' | '
	EndIf
	If $aActions[2] Then
		$sActions = $sActions & "call " & $aActions[2] & ' | '
	EndIf
	If $aActions[3] Then
		$sActions = $sActions & 'check ' & $aActions[3] & ' | '
	EndIf
	If $aActions[4] Then
		$sActions = $sActions & 'fold ' & $aActions[4] & ' | '
	EndIf
	If $aActions[5] Then
		$sActions = $sActions & 'winner ' & $aActions[5] & ' | '
	EndIf
	If $sActions Then
		$sActions = StringLeft($sActions,StringLen($sActions)-3)

	EndIf
	Return $sActions
EndFunc

Func _ActionCheck($iAction)
	Local $iChecksum, $sFilename
	$iChecksum = _ActionChecksum($iAction)

	; load from dictionary
	If IsObj($oActionDictionary) And $oActionDictionary.Exists($iChecksum) Then
		Return $oActionDictionary.Item($iChecksum)
	EndIf

	; load from TXT
	If FileExists($sDataPath&'\action\empty\'&$iChecksum&'.txt') Then
		If IsObj($oActionDictionary) Then
			$oActionDictionary.Add($iChecksum,False)
		EndIf
		Return False
	EndIf
	Local $aFolders[6] = ["all in","raise","call","check","fold","winner"]
	For $i=0 To 5
		If FileExists($sDataPath&'\action\'&$aFolders[$i]&'\'&$iChecksum&'.txt') Then
			$sAction = $aFolders[$i]
			If IsObj($oActionDictionary) Then
				$oActionDictionary.Add($iChecksum,$sAction)
			EndIf
			Return $sAction
		EndIf
	Next
	
	; load from TIF
	If FileExists($sDataPath&'\action\empty\'&$iChecksum&'.tif') Then
		FileWrite($sDataPath&'\action\empty\'&$iChecksum&'.txt','empty') ; save to TXT
		If IsObj($oActionDictionary) Then
			$oActionDictionary.Add($iChecksum,False)
		EndIf
		Return False
	EndIf
	Local $aFolders[6] = ["all in","raise","call","check","fold","winner"]
	For $i=0 To 5
		If FileExists($sDataPath&'\action\'&$aFolders[$i]&'\'&$iChecksum&'.tif') Then
			$sAction = $aFolders[$i]
			FileWrite($sDataPath&'\action\'&$aFolders[$i]&'\'&$iChecksum&'.txt',$sAction) ; save to TXT
			If IsObj($oActionDictionary) Then
				$oActionDictionary.Add($iChecksum,$sAction)
			EndIf
			Return $sAction
		EndIf
	Next
	
	; not found
	$aAction = _ActionPosition($iAction)
	If $logScreenAction <> 0 Then
		_ScreenCapture_Capture($sDataPath&'\action\'&$iChecksum&'.tif',$aTop[0]+$aAction[0],$aTop[1]+$aAction[1],$aTop[0]+$aAction[0]+25,$aTop[1]+$aAction[1]+10,False)
	EndIf

	Return False
EndFunc

Func _ActionChecksum($iAction)
	Local $aAction, $iChecksum
	$aAction = _ActionPosition($iAction)
 	$iChecksum = PixelChecksum($aTop[0]+$aAction[0],$aTop[1]+$aAction[1],$aTop[0]+$aAction[0]+25,$aTop[1]+$aAction[1]+10)
	Return $iChecksum
EndFunc


Func _ActionChecksumSave($iAction)
	Local $iChecksum, $sFilename
	$iChecksum = _ActionChecksum($iAction)
	$sFilename = $sDataPath&'\action\'&$iChecksum
	If FileExists($sFilename&'.txt') Then
		Return
	EndIf
	FileWrite($sFilename&'.txt',$iAction)
EndFunc



Func _ActionPosition($iAction)
	Local $aActionXY[9][2], $aAction[2]

	; Action 1
	$aActionXY[0][0] = 487
	$aActionXY[0][1] = 93

	; Action 2
	$aActionXY[1][0] = 597
	$aActionXY[1][1] = 143

	; Action 3
	$aActionXY[2][0] = 607
	$aActionXY[2][1] = 266

	; Action 4
	$aActionXY[3][0] = 487
	$aActionXY[3][1] = 338

	; Action 5
	$aActionXY[4][0] = 361
	$aActionXY[4][1] = 343

	; Action 6
	$aActionXY[5][0] = 246
	$aActionXY[5][1] = 338

	; Action 7
	$aActionXY[6][0] = 127
	$aActionXY[6][1] = 266

	; Action 8
	$aActionXY[7][0] = 127
	$aActionXY[7][1] = 143

	; Action 9
	$aActionXY[8][0] = 247
	$aActionXY[8][1] = 93

	$aAction[0] = $aActionXY[$iAction-1][0]
	$aAction[1] = $aActionXY[$iAction-1][1]
	Return $aAction
EndFunc

