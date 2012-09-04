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
; Simple Check Bot
;=================================================================
#include-once
Global $iBlind = 0

Func CheckBot()
	If $iBlind==0 Then
		$iBlind = _Blind()
	EndIf
	$iSeat = _Seat()
	$sHand = _Cards($iSeat)
	$sStreet = _Street($sHand)

	If $sStreet=='NOGAME' Then
		_Log('OK - nogame')
		$iStuck = $iStuck+1
		CheckBot_NOGAME($iSeat,$sHand)
	ElseIf $sStreet=='PREFLOP' Then
		_Log('OK - preflop')
		$iStuck = 0
		CheckBot_PREFLOP($iSeat,$sHand)
	Else
		_Log('OK - game')
		CheckBot_GAME($iSeat,$sHand)
	EndIf
EndFunc

Func CheckBot_NOGAME($iSeat,$sHand)
	$iButton = _Button()
	$iPosition = _ButtonSeat($iSeat)+1
	$iOpponents = _OpponentCount()
	$aActionCount = _ActionCount()
	$sDebug = 'Hand: '&$sHand&@CRLF&'Blind: '&$iBlind&@CRLF&'Position: '&$iPosition&@CRLF&'Button: '&$iButton&@CRLF&'Players: '&$iOpponents&@CRLF&_ActionString($aActionCount)

	_Log('OK - NOGAME')
	_Log('OK - $iSeat = '&$iSeat)
	_Log('OK - $sHand = '&$sHand)
	_Log('OK - $iBlind = '&$iBlind)
	_Log('OK - $iButton = '&$iButton)
	_Log('OK - $iPosition = '&$iPosition)
	_Log('OK - $iOpponents = '&$iOpponents)
	_Log('OK - $aActionCount = '&_ActionString($aActionCount))

	_ToolTip($sDebug,'No Game')
EndFunc

Func CheckBot_PREFLOP($iSeat,$sHand)
	$iNoGameCount = 0
	$aCards = _CardNumbersArray($sHand)
	$aSuits = _CardSuitsArray($sHand)
	$iOpponents = _OpponentCount()
	$iButton = _Button()
	$iPosition = _ButtonSeat($iSeat)+1
	$aActionCount = _ActionCount()
	$sDebug = 'Hand: '&$sHand&@CRLF&'Blind: '&$iBlind&@CRLF&'Position: '&$iPosition&@CRLF&'Button: '&$iButton&@CRLF&'Players: '&$iOpponents&@CRLF&_ActionString($aActionCount)
	
	_Log('OK - $iSeat = '&$iSeat)
	_Log('OK - $sHand = '&$sHand)
	_Log('OK - $iBlind = '&$iBlind)
	_Log('OK - $iButton = '&$iButton)
	_Log('OK - $iPosition = '&$iPosition)
	_Log('OK - $iOpponents = '&$iOpponents)
	_Log('OK - $aActionCount = '&_ActionString($aActionCount))

	_ToolTip($sDebug,'Check')
	_Log('OK - Check')
	_PlayTurnCheck()
EndFunc

Func CheckBot_GAME($iSeat,$sHand)
	$iNoGameCount = 20
	$iNoGameReason = 'just played a hand'
	$iOpponents = _OpponentCount()
	$iPosition = _ButtonSeat($iSeat)+1
	$iButton = _Button()
	$aActionCount = _ActionCount()
	$iScore = _SimHandMulti($sHand, $iOpponents-1) * $iOpponents
	$sDebug = 'Hand: '&$sHand&@CRLF&'Blind: '&$iBlind&@CRLF&'Position: '&$iPosition&@CRLF&'Button: '&$iButton&@CRLF&'Players: '&$iOpponents&@CRLF&'Score: '&$iScore&@CRLF&_ActionString($aActionCount)

	_Log('OK - $iSeat = '&$iSeat)
	_Log('OK - $sHand = '&$sHand)
	_Log('OK - $iBlind = '&$iBlind)
	_Log('OK - $iButton = '&$iButton)
	_Log('OK - $iPosition = '&$iPosition)
	_Log('OK - $iOpponents = '&$iOpponents)
	_Log('OK - $aActionCount = '&_ActionString($aActionCount))
	_Log('OK - $iScore = '&$iScore)

	_Log('OK - Check')
	_ToolTip($sDebug,'Check')
	_PlayTurnCheck()
EndFunc

