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
; Hand History Functions
;=================================================================
#include-once
Global $sLogPath = '..\log'
Global $bLogHand = 0
Global $sPreviousHand

Func _HandHistory($sHand)
	If $bLogHand Then
		If 	$sPreviousHand <> $sHand Then
			$sPreviousHand = $sHand
			$sDate = (@YEAR & "-" & @MON & "-" & @MDAY & "-" & @HOUR & "-" & @MIN & "-" & @SEC) 
			$sFilename = $sLogPath&'\hand_'&(@YEAR & "-" & @MON & "-" & @MDAY & "-" & @HOUR)&'.txt'
			FileWriteLine($sFilename,$sDate&': '&$sHand&' Score: ' &$iScore&' Score Adj: ' &$zScore& @CRLF)
		EndIf
	EndIf
EndFunc