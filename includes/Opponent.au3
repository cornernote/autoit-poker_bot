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
; Opponent Functions
;=================================================================
#include-once
#Include "Table.au3"
#include "Debug.au3"

Global $oOpponentDictionary = ObjCreate("Scripting.Dictionary")

Func _OpponentCount()
	Local $iOpponentCount = 0 ; counts self as an opponent
	For $i = 1 To 9
		If _OpponentCard($i) Then
			$iOpponentCount = $iOpponentCount+1
		EndIf
	Next
	Return $iOpponentCount
EndFunc

Func _OpponentCard($iSeat)
	Local $aOpponentsXY[2], $iPixelColour, $iOpponentColour
	
	$aOpponentsXY = _OpponentCardPosition($iSeat)
	$iPixelColour = PixelGetColor($aTop[0]+$aOpponentsXY[0],$aTop[1]+$aOpponentsXY[1])
	
	If IsObj($oOpponentDictionary) And $oOpponentDictionary.Exists($iPixelColour&$iSeat) Then
		Return $oOpponentDictionary.Item($iPixelColour&$iSeat)
	EndIf
	
	$iOpponentColour = IniRead($sDataPath & "\opponent.ini","NoOpponent","checksum"&$iSeat,0)
	;_Log('_OpponentCard: '&$iPixelColour)
	If $iOpponentColour And $iPixelColour <> $iOpponentColour Then
		If IsObj($oOpponentDictionary) Then
			$oOpponentDictionary.Add($iPixelColour&$iSeat,True)
		EndIf
		Return True
	EndIf
	
	If IsObj($oOpponentDictionary) Then
		$oOpponentDictionary.Add($iPixelColour&$iSeat,False)
	EndIf
	Return False
EndFunc

Func _OpponentCardSave()
	Local $aOpponentsXY[2], $sContents, $iPixelColour
	
	$sContents = '[NoOpponent]' & @CRLF
	For $i = 1 To 9
		$aOpponentsXY = _OpponentCardPosition($i)
		$iPixelColour = PixelGetColor($aTop[0]+$aOpponentsXY[0],$aTop[1]+$aOpponentsXY[1])
		$sContents = $sContents & 'checksum' & $i & '=' & $iPixelColour & @CRLF
	Next

	$sFileName = $sDataPath & "\opponent.ini"
	If FileExists($sFileName) Then
		FileDelete($sFileName)
	EndIf
	FileWrite($sFileName,$sContents)
EndFunc

Func _OpponentCardPosition($iSeat)
	Local $aOpponentsXY[9][2], $aPosition[2]
	
	; Opponent 1
	$aOpponentsXY[0][0] = 460
	$aOpponentsXY[0][1] = 95

	; Opponent 2
	$aOpponentsXY[1][0] = 558
	$aOpponentsXY[1][1] = 131

	; Opponent 3
	$aOpponentsXY[2][0] = 569
	$aOpponentsXY[2][1] = 209

	; Opponent 4
	$aOpponentsXY[3][0] = 470
	$aOpponentsXY[3][1] = 245

	; Opponent 5
	$aOpponentsXY[4][0] = 380
	$aOpponentsXY[4][1] = 249

	; Opponent 6
	$aOpponentsXY[5][0] = 290
	$aOpponentsXY[5][1] = 244

	; Opponent 7
	$aOpponentsXY[6][0] = 192
	$aOpponentsXY[6][1] = 210

	; Opponent 8
	$aOpponentsXY[7][0] = 200
	$aOpponentsXY[7][1] = 131

	; Opponent 9
	$aOpponentsXY[8][0] = 300
	$aOpponentsXY[8][1] = 95

	$aPosition[0] = $aOpponentsXY[$iSeat-1][0]
	$aPosition[1] = $aOpponentsXY[$iSeat-1][1]
	Return $aPosition

EndFunc