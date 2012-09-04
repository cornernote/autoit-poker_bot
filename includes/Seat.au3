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
; Seat Functions
;=================================================================
#include-once
#include <GUIConstants.au3>
#Include "Table.au3"
#Include "Button.au3"

Global $oSeatDictionary = ObjCreate("Scripting.Dictionary")
Global $sDataPath = '..\data'
;Global $iSeatNum = 0
;HotKeySet("!^s", "_SeatChoose")

Func _Seat()
	Local $iSeat = 0
	For $i = 1 To 9
		If _SeatCheck($i,'player') Then
			$iSeat = $i
			ExitLoop
		EndIf
	Next
	If $iSeat Then
		$iSitStuck = 0
		Return $iSeat
	Else
		;TrayTip('WARNING', 'seat not found - press CTRL+ALT+S to select seat', 2000)
		Return False
	EndIf
EndFunc

Func _SeatCountEmpty()
	Local $iSeatEmptyCount = 0
	For $i = 1 To 9
		If _SeatCheck($i,'empty') Then
			$iSeatEmptyCount = $iSeatEmptyCount+1
		EndIf
	Next
	Return $iSeatEmptyCount
EndFunc

Func _SeatAvailable()
	Local $iButton = _Button()
	For $i = 1 To 9
		$iSeat = $iButton-$i+2
		If $iSeat<1 Then
			$iSeat = $iSeat+9
		EndIf
		If $iSeat>9 Then
			$iSeat = $iSeat-9
		EndIf
		If _SeatCheck($iSeat,'sit') Then
			Return $iSeat
		EndIf
	Next
	_ToolTip('No empty seat found, ' & @CRLF & ' please ensure your seat data exists.','Warning')
	$aLobby = $aLobby + 1
	Return 0

EndFunc

Func _SeatEmpty()
	Local $iButton = _Button()
	Local $iMySeat = _Seat()
	If Not $iButton Or Not $iMySeat Then Return 0
	For $i = 0 To 5
		$iSeat = $iButton-$i+1
		If $iSeat<1 Then
			$iSeat = $iSeat+9
		EndIf
		If $iSeat>9 Then
			$iSeat = $iSeat-9
		EndIf
		If $iMySeat==$iSeat Then
			Return 0
		EndIf
		If _SeatCheck($iSeat,'empty') Then
			Return $iSeat
		EndIf
	Next
	Return 0
EndFunc

Func _SeatCheck($iSeat,$sType)
	Local $iChecksum, $sFilename
	$iChecksum = _SeatChecksum($iSeat,$sType)

	If IsObj($oSeatDictionary) And $oSeatDictionary.Exists($sType&$iSeat&$iChecksum) Then
		Return $oSeatDictionary.Item($sType&$iSeat&$iChecksum)
	EndIf

	$sFilename = $sDataPath&'\seat\'&$sType&'.'&$iSeat&'.'&$iChecksum&'.txt'
	If FileExists($sFilename) Then
		If IsObj($oSeatDictionary) Then
			$oSeatDictionary.Add($sType&$iSeat&$iChecksum,True)
		EndIf
		Return True
	EndIf

	If IsObj($oSeatDictionary) Then
		$oSeatDictionary.Add($sType&$iSeat&$iChecksum,False)
	EndIf
	Return False
EndFunc

Func _SeatChecksumSave($iSeat,$sType)
	Local $iChecksum, $sFilename
	$iChecksum = _SeatChecksum($iSeat,$sType)
	$sFilename = $sDataPath&'\seat\'&$sType&'.'&$iSeat&'.'&$iChecksum&'.txt'
	If FileExists($sFilename) Then
		Return
	EndIf
	FileWrite($sFilename,$iSeat)
EndFunc

Func _SeatChecksum($iSeat,$sType)
	Local $aSeat, $iChecksum
	$aSeat = _SeatPosition($iSeat)
 	$iChecksum = PixelChecksum($aTop[0]+$aSeat[0]+10,$aTop[1]+$aSeat[1],$aTop[0]+$aSeat[0]+10,$aTop[1]+$aSeat[1]+10)
	_ScreenCapture_Capture($sDataPath&'\SeatCheck\'&$sType&$iSeat&'-'&$iChecksum&'.tif',$aTop[0]+$aSeat[0],$aTop[1]+$aSeat[1],$aTop[0]+$aSeat[0]+10,$aTop[1]+$aSeat[1]+10,False)
	Return $iChecksum
EndFunc

;Func _SeatChecksum($iSeat,$sType)
	;Local $aSeat, $iChecksum
	;$aSeat = _SeatPosition($iSeat)
	;$aSeat = _SeatPosition($iSeatNum)
	;$x = $aTop[0]+$aSeat[0]+10
	;$y = $aTop[1]+$aSeat[1]
	;$w = 10
	;$h = 10
	;return PixelChecksum($x,$y,$x+$w,$y+$h)
;EndFunc

Func _SeatPosition($iSeat)
	Local $aSeatXY[9][2], $aSeat[2]
	If Not $iSeat Or $iSeat>9 Or $iSeat<1 Then Return $aSeat

	; seat 1
	$aSeatXY[0][0] = 488
	$aSeatXY[0][1] = 47

   ; seat 2
   ;$aSeatXY[1][0] = 600
   ;$aSeatXY[1][1] = 95
	$aSeatXY[1][0] = 598
	$aSeatXY[1][1] = 97

   ; seat 3
   ;$aSeatXY[2][0] = 610
   ;$aSeatXY[2][1] = 216
	$aSeatXY[2][0] = 608
	$aSeatXY[2][1] = 220
	
   ; seat 4
   ;$aSeatXY[3][0] = 490
   ;$aSeatXY[3][1] = 278
	$aSeatXY[3][0] = 488
	$aSeatXY[3][1] = 292

   ; seat 5
   ;$aSeatXY[4][0] = 365
   ;$aSeatXY[4][1] = 293
	$aSeatXY[4][0] = 363
	$aSeatXY[4][1] = 297

   ; seat 6
   ;$aSeatXY[5][0] = 250
   ;$aSeatXY[5][1] = 278
	$aSeatXY[5][0] = 248
	$aSeatXY[5][1] = 292

   ; seat 7
   ;$aSeatXY[6][0] = 130
   ;$aSeatXY[6][1] = 218
	$aSeatXY[6][0] = 128
	$aSeatXY[6][1] = 220

   ; seat 8
   ;$aSeatXY[7][0] = 130
   ;$aSeatXY[7][1] = 98
	$aSeatXY[7][0] = 128
	$aSeatXY[7][1] = 97

   ; seat 9
   ;$aSeatXY[8][0] = 250
   ;$aSeatXY[8][1] = 44
	$aSeatXY[8][0] = 248
	$aSeatXY[8][1] = 47

	$aSeat[0] = $aSeatXY[$iSeat-1][0]
	$aSeat[1] = $aSeatXY[$iSeat-1][1]
	Return $aSeat
EndFunc

Func _SeatChoose()
    Local $guiSeat, $guiSeatOptions[9], $msg, $iSeat, $bLoop
    $guiSeat = GUICreate("Choose Seat", 200, 200, @DesktopWidth-250, @DesktopHeight-400)
    $guiSeatOptions[0] = GUICtrlCreateRadio("Seat 1", 10, 10, 120, 20)
    $guiSeatOptions[1] = GUICtrlCreateRadio("Seat 2", 10, 30, 120, 20)
    $guiSeatOptions[2] = GUICtrlCreateRadio("Seat 3", 10, 50, 120, 20)
    $guiSeatOptions[3] = GUICtrlCreateRadio("Seat 4", 10, 70, 120, 20)
    $guiSeatOptions[4] = GUICtrlCreateRadio("Seat 5", 10, 90, 120, 20)
    $guiSeatOptions[5] = GUICtrlCreateRadio("Seat 6", 10, 110, 120, 20)
    $guiSeatOptions[6] = GUICtrlCreateRadio("Seat 7", 10, 130, 120, 20)
    $guiSeatOptions[7] = GUICtrlCreateRadio("Seat 8", 10, 150, 120, 20)
    $guiSeatOptions[8] = GUICtrlCreateRadio("Seat 9", 10, 170, 120, 20)
    GUISetState()

	; Run the GUI until the dialog is closed
	$bLoop = True
    While $bLoop
        $msg = GUIGetMsg()
		If $msg = $GUI_EVENT_CLOSE Then
			ExitLoop
		EndIf
		For $i = 0 To 8
			If $msg = $guiSeatOptions[$i] And BitAND(GUICtrlRead($guiSeatOptions[$i]), $GUI_CHECKED) = $GUI_CHECKED Then
				$iSeat = $i+1
				_SeatChecksumSave($iSeat,'player')
				$bLoop = False
				ExitLoop
			EndIf
		Next
		WEnd
	GUISetState(@SW_HIDE, $guiSeat)
	Return $iSeat
EndFunc

