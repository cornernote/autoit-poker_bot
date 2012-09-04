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
; Bingo Bot
;=================================================================

#include-once
Global $iMinBlind = Int(IniRead(@ScriptDir & "\settings.ini","Table","table_min_blind",1))
Global $iMaxBlind = Int(IniRead(@ScriptDir & "\settings.ini","Table","table_max_blind",2000000))
Global $iMinPlayers = Int(IniRead(@ScriptDir & "\settings.ini","Table","table_min_players",6))
Global $iBlind = 0
Global $bRaised = False
Global $bForceBank = False
Global $iStuck = 0
Global $iCashChange = 0

Func BingoBot()
	If $iBlind==0 Then
		$iBlind = _Blind()
	EndIf
	$iSeat = _Seat()
	$sHand = _Cards($iSeat)
	$sStreet = _Street($sHand)
	_HandHistory($sHand)
		
	If $sStreet=='NOGAME' Or $bForceBank Then
		If $bForceBank Then
			_Log('OK - forcebank')
		EndIf
		_Log('OK - nogame')
		$iStuck = $iStuck+1
		BingoBot_NOGAME($iSeat,$sHand)
		$bForceBank = False
	ElseIf $sStreet=='PREFLOP' Then
		_Log('OK - preflop')
		$iStuck = 0
		BingoBot_PREFLOP($iSeat,$sHand)
	Else
		_Log('OK - game')
		BingoBot_GAME($iSeat,$sHand)
	EndIf
EndFunc

Func BingoBot_NOGAME($iSeat,$sHand)
	$iButton = _Button()
	$iPosition = _ButtonSeat($iSeat)+1
	$iOpponents = _OpponentCount()
	$aActionCount = _ActionCount()
	$sDebug = 'Hand: '&$sHand&@CRLF&'Blind: '&$iBlind&@CRLF&'Position: '&$iPosition&@CRLF&'Button: '&$iButton&@CRLF&'Players: '&$iOpponents&@CRLF&_ActionString($aActionCount)

	_Log('OK - $iSeat = '&$iSeat)
	_Log('OK - $sHand = '&$sHand)
	_Log('OK - $iBlind = '&$iBlind)
	_Log('OK - $iButton = '&$iButton)
	_Log('OK - $iPosition = '&$iPosition)
	_Log('OK - $iOpponents = '&$iOpponents)
	_Log('OK - $aActionCount = '&_ActionString($aActionCount))

	; if no forced bank, check for a pause
	If Not $bForceBank Then
		; wait after a winner is detected
		If $aActionCount[5] Then
			_Log('OK - waiting because someone won')
			_ToolTip('someone won','Waiting')
			Sleep(1000)
			;_ScreenCapture('winner')
			$iNoGameReason = 'someone won'
			$iNoGameCount = 10
			Return
		EndIf
	EndIf

	; if we are not waiting, check room conditions
	If $iNoGameCount <= 0 Then
		
		; check blind size
		If $iBlind==0 Then
			_Log('WARNING - blinds could not be read')
			_ToolTip('blinds could not be read','Bad Room')
			_TableStand()
			_Lobby()
			Return
		EndIf
		
		If $iBlind < $iMinBlind Then
			_Log('WARNING - blinds too small ('&$iBlind&')')
			_ToolTip('blinds too small ('&$iBlind&'), going to lobby','Bad Room')
			_TableStand()
			_Lobby()
			Return
		EndIf
		
		If $iBlind > $iMaxBlind Then
			_Log('WARNING - blinds too high ('&$iBlind&')')
			_ToolTip('blinds too high, going to lobby','Bad Room')
			_TableStand()
			_Lobby()
			Return
		EndIf
		
		; check number of players
		If (9-_SeatCountEmpty() < $iMinPlayers) Then
			_Log('WARNING - not enough players')
			_ToolTip('not enough players, going to lobby','Bad Room')
			_TableStand()
			_Lobby()
			Return
		EndIf
		
		; bank if needed
		If $iCashChange Then
			_Log('OK - banking')
			_ToolTip('need to bank','Banking')
			_TableBank()
			Return
		EndIf
		
		_Chat()
		_ToolTip($sDebug,'No Game')
	EndIf
		
	; decrement the wait timer
	If $iNoGameCount > 0 Then
		_Log('OK - paused '& $iNoGameCount)
		$iNoGameCount = $iNoGameCount-1
		_ToolTip($iNoGameReason & @CRLF & 'paused '& $iNoGameCount,'Waiting')
	EndIf
EndFunc

Func BingoBot_PREFLOP($iSeat,$sHand)
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

	; reset decisions
	$bRaised = False
	
	;
	; decide if we should raise
	;	

	; AA, KK
	If $aCards[0] == $aCards[1] And ($aCards[0] == 'A' Or $aCards[0] == 'K') Then
		_Log('OK - AA/KK')
		$bRaised = True
	EndIf
	
	; AK
	If ($aCards[0] == 'A' And $aCards[1] == 'K') Or ($aCards[0] == 'K' And $aCards[1] == 'A') Then
		_Log('OK - AK')
		$bRaised = True
	EndIf
		
	; QQ, JJ, TT
	If $aCards[0] == $aCards[1] And ($aCards[0] == 'Q' Or $aCards[0] == 'J' Or $aCards[0] == 'T') Then
		_Log('OK - QQ/JJ/TT')
		$bRaised = True
	EndIf
	
	; AQ, AJ
	If ($aCards[0] == 'A' And $aCards[1] == 'Q') Or ($aCards[0] == 'Q' And $aCards[1] == 'A') Or ($aCards[0] == 'A' And $aCards[1] == 'J') Or ($aCards[0] == 'J' And $aCards[1] == 'A') Then
		_Log('OK - AQ/AJ')
		$bRaised = True
	EndIf
	
	; AT
	If ($aCards[0] == 'A' And $aCards[1] == 'T') Or ($aCards[0] == 'T' And $aCards[1] == 'A') Then
		_Log('OK - AT')
		$bRaised = True
	EndIf
	
	;
	; lets do it !
	;	
	If $bRaised Then
		$iCashChange = True
		_Log('OK - Raise')
		_ToolTip($sDebug,'Raise')
		_PlayTurnRaise($iBlind*1000, 'any')
	Else
		_Log('OK - Check')
		_ToolTip($sDebug,'Check')
		_PlayTurnCheck()
	EndIf

EndFunc

Func BingoBot_GAME($iSeat,$sHand)
	$iNoGameCount = 10
	$iNoGameReason = 'just played a hand'
	$iOpponents = _OpponentCount()
	$iPosition = _ButtonSeat($iSeat)+1
	$iButton = _Button()
	$aActionCount = _ActionCount()
	$iScore = _SimHandMulti($sHand, $iOpponents-1)
	$sDebug = 'Hand: '&$sHand&@CRLF&'Blind: '&$iBlind&@CRLF&'Position: '&$iPosition&@CRLF&'Button: '&$iButton&@CRLF&'Players: '&$iOpponents&@CRLF&'Score: '&$iScore&@CRLF&_ActionString($aActionCount)

	_Log('OK - $iSeat = '&$iSeat)
	_Log('OK - $sHand = '&$sHand)
	_Log('OK - $iBlind = '&$iBlind)
	_Log('OK - $iButton = '&$iButton)
	_Log('OK - $iPosition = '&$iPosition)
	_Log('OK - $iOpponents = '&$iOpponents)
	_Log('OK - $aActionCount = '&_ActionString($aActionCount))
	_Log('OK - $iScore = '&$iScore)

	; bot has only checked until now, so play tight
	If $iScore>=0.85 Then
		$iCashChange = True
		_Log('OK - Raise')
		_ToolTip($sDebug,'Raise')
		_PlayTurnRaise($iBlind*1000, 'any')
	
	; score is too low to raise
	Else
		_Log('OK - Check')
		_ToolTip($sDebug,'Check')
		_PlayTurnCheck()
	EndIf 
	
EndFunc

