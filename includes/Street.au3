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
; Street Functions
;=================================================================
#include-once
#include <Array.au3>

Func _Street($sCards)
	Local $aCards, $iCardCount

	$aCards = StringSplit($sCards, ' ')
	If $aCards[1] == '--' Then
		$iCardCount = 0
	Else
		$iCardCount = Ubound($aCards) - 1
	EndIf
	
	If $iCardCount < 2 Then
		Return 'NOGAME'
	EndIf

	If $iCardCount == 2 Then
		Return 'PREFLOP'
	EndIf

	If $iCardCount == 5 Then
		Return 'FLOP'
	EndIf

	If $iCardCount == 6 Then
		Return 'TURN'
	EndIf

	If $iCardCount == 7 Then
		Return 'RIVER'

	EndIf
EndFunc


;=================================================================
; Tests
;=================================================================

;ConsoleWrite(_Street(False) & @CRLF)
;ConsoleWrite(_Street('') & @CRLF)
;ConsoleWrite(_Street('-- --') & @CRLF)
;ConsoleWrite(_Street('Ah 6c') & @CRLF)
;ConsoleWrite(_Street('Ah 6c Th Jh Qh') & @CRLF)
;ConsoleWrite(_Street('Ah 6c Th Jh Qh Kh') & @CRLF)
;ConsoleWrite(_Street('Ah 6c Th Jh Qh Kh 9h') & @CRLF)

