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
; Button Functions
;=================================================================
#include-once
#Include "Table.au3"
#Include "Debug.au3"

Func _Button()
	Local $iButton = 0
	For $i = 1 To 9
		$aButton = _ButtonPosition($i)
		$iColor = PixelGetColor($aTop[0]+$aButton[0],$aTop[1]+$aButton[1])
		If $iColor==0 Then
			$iButton = $i
			ExitLoop
		EndIf
	Next
	Return $iButton
EndFunc

Func _ButtonSeat($iSeat)
	$iButton = _Button()
	If $iSeat < $iButton Then $iSeat = $iSeat+9
	Return $iSeat - $iButton
EndFunc

Func _ButtonPosition($iButton)
	Local $aButtonXY[9][2], $aButton[2]

	; Button 1
	$aButtonXY[0][0] = 444
	$aButtonXY[0][1] = 94

	; Button 2
	$aButtonXY[1][0] = 589 
	$aButtonXY[1][1] = 164

	; Button 3
	$aButtonXY[2][0] = 549
	$aButtonXY[2][1] = 229

	; Button 4
	$aButtonXY[3][0] = 471
	$aButtonXY[3][1] = 229

	; Button 5
	$aButtonXY[4][0] = 414
	$aButtonXY[4][1] = 252

	; Button 6
	$aButtonXY[5][0] = 294
	$aButtonXY[5][1] = 236

	; Button 7
	$aButtonXY[6][0] = 214
	$aButtonXY[6][1] = 226

	; Button 8
	$aButtonXY[7][0] = 170
	$aButtonXY[7][1] = 165

	; Button 9
	$aButtonXY[8][0] = 314
	$aButtonXY[8][1] = 93

	$aButton[0] = $aButtonXY[$iButton-1][0]
	$aButton[1] = $aButtonXY[$iButton-1][1]
	Return $aButton
EndFunc

