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
; Debug Functions
;=================================================================
#include-once
#Include "vendor/ScreenCapture/ScreenCaptureFixed.au3"
#Include "Table.au3"

Global $bLogText = 1
Global $sLogPath = 'log'
Global $logScreenCapture = 0
Global $aTop[2]
Global $browserTitle
Global $sWindowTitle="0x0005089E"

Func _ToolTip($sText,$sTitle='',$iStatus=1)
	If $aTop[0] Then
		ToolTip(_DebugArray($sText), $aTop[0]+3, ($aTop[1]+360), $sTitle, $iStatus, 4)
	Else
		Local $aWinPos = WinGetPos($browserTitle)
		If IsArray($aWinPos) Then
			ToolTip(_DebugArray($sText), $aWinPos[0]+11, $aWinPos[1]+36+000, $sTitle, $iStatus, 4)
		Else
			ToolTip(_DebugArray($sText), 5, (@DesktopHeight-150),  $sTitle, $iStatus, 4)
		EndIf
	EndIf
EndFunc

Func _Log($sText)
	If $bLogText Then
		$sDate = (@YEAR & "-" & @MON & "-" & @MDAY & "-" & @HOUR & "-" & @MIN & "-" & @SEC) 
		$sFilename = $sLogPath&'\log_'&(@YEAR & "-" & @MON & "-" & @MDAY & "-" & @HOUR)&'.txt'
		FileWriteLine($sFilename,$sDate&': '&_DebugArray($sText))
		ConsoleWrite($sDate&': '&_DebugArray($sText))
	EndIf
EndFunc

; timer debug
Func d($sText,$tBegin=0) 
	If Not $tBegin Then
		$tBegin = TimerInit()
		;ConsoleWrite('begin: '&$sText&@CRLF)
		Return $tBegin
	Else
		ConsoleWrite('end: '&$sText&' in '&Int(TimerDiff($tBegin))&'ms'&@CRLF)
	EndIf
EndFunc

Func _DebugArray($aArray,$sPad='')
	$sString = ''
	If (IsArray($aArray)) Then
		$sString = $sString & $sPad & 'array:' & @CRLF
		For $a In $aArray
			$sString = $sString & _DebugArray($a, $sPad & '> ')
		Next
	Else
		$sString = $sString & $sPad & $aArray & @CRLF
	EndIf
	Return $sString
EndFunc

Func _ScreenCapture()
	If $logScreenCapture Then
		$sDate = (@YEAR & "-" & @MON & "-" & @MDAY & "_" & @HOUR & "-" & @MIN & "-" & @SEC) 
		$sImageFilename = $sLogPath&'\screen\'&$sDate
		If $aTop[0] Then
			_ScreenCapture_Capture($sImageFilename&'.tif',$aTop[0],$aTop[1],$aTop[0]+760,$aTop[1]+530,False)
		Else
			_ScreenCapture_Capture($sImageFilename&'.tif',0,0,@DesktopWidth,@DesktopHeight,False)
		EndIf
	EndIf
EndFunc