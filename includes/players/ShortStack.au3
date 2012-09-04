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
; Short Stack
;=================================================================

#include-once
Global $iMinBlind = Int(IniRead(@ScriptDir & "\settings.ini","Table","table_min_blind",1))
Global $iMaxBlind = Int(IniRead(@ScriptDir & "\settings.ini","Table","table_max_blind",2000000))
Global $iMinPlayers = Int(IniRead(@ScriptDir & "\settings.ini","Table","table_min_players",6))
Global $iBlind = 0
Global $bRaised = False
Global $bCalled = False
Global $bGoAllIn = False
Global $bForceBank = False
Global $iStuck = 0
Global $iCashChange = False

Func ShortStack()
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
		ShortStack_NOGAME($iSeat,$sHand)
		$bForceBank = False
	ElseIf $sStreet=='PREFLOP' Then
		_Log('OK - preflop')
		$iStuck = 0
		ShortStack_PREFLOP($iSeat,$sHand)
	Else
		_Log('OK - game')
		ShortStack_GAME($iSeat,$sHand)
	EndIf
EndFunc

Func ShortStack_NOGAME($iSeat,$sHand)
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

Func ShortStack_PREFLOP($iSeat,$sHand)
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
	$bCalled = False
	$bRaised = False
	$bGoAllIn = False
	
	;
	; decide if we should go all in
	;	

	; AA, KK
	If $aCards[0] == $aCards[1] And ($aCards[0] == 'A' Or $aCards[0] == 'K') Then
		_Log('OK - AA/KK')
		$bGoAllIn = True
	EndIf
	
	;
	; decide if we should raise
	;	

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
	; decide if we should call
	;	

	; nobody raised or went all in
	If $aActionCount[0]==0 And $aActionCount[1]==0 Then 

		;; KQ
		;If ($aCards[0] == 'K' And $aCards[1] == 'Q') Or ($aCards[0] == 'Q' And $aCards[1] == 'K') Then
		;	_Log('OK - KQ')
		;	$bCalled = True
		;EndIf

		;; KJ
		;If ($aCards[0] == 'K' And $aCards[1] == 'J') Or ($aCards[0] == 'J' And $aCards[1] == 'K') Then
		;	_Log('OK - KJ')
		;	$bCalled = True
		;EndIf

		;; QJ
		;If ($aCards[0] == 'Q' And $aCards[1] == 'J') Or ($aCards[0] == 'J' And $aCards[1] == 'Q') Then
		;	_Log('OK - QJ')
		;	$bCalled = True
		;EndIf

		;; QT
		;If ($aCards[0] == 'Q' And $aCards[1] == 'T') Or ($aCards[0] == 'T' And $aCards[1] == 'Q') Then
		;	_Log('OK - QT')
		;	$bCalled = True
		;EndIf

		;; JT
		;If ($aCards[0] == 'J' And $aCards[1] == 'T') Or ($aCards[0] == 'T' And $aCards[1] == 'J') Then
		;	_Log('OK - JT')
		;	$bCalled = True
		;EndIf

		;; pocket pair
		;If $aCards[0] == $aCards[1]Then
		;	_Log('OK - pocket pair')
		;	$bCalled = True
		;EndIf
		
		;; 99, 88, 77
		;If $aCards[0] == $aCards[1] And ($aCards[0] == '9' Or $aCards[0] == '8' Or $aCards[0] == '7') Then
		;	_Log('OK - 99/88/77')
		;	$bCalled = True
		;EndIf
		
		;; 66, 55, 44, 33, 22
		;If $aCards[0] == $aCards[1] And ($aCards[0] == '6' Or $aCards[0] == '5' Or $aCards[0] == '4' Or $aCards[0] == '3' Or $aCards[0] == '2') Then
		;	_Log('OK - 66/55/44/33/22')
		;	$bCalled = True
		;EndIf
		
		;; suited
		;If ($aSuits[0] == $aSuits[1]) Then
		;	_Log('OK - suited')
		;	$bRaised = True
		;EndIf
		
		;; suited connectors
		;If $aSuits[0] == $aSuits[1] Then ; suited
		;	; connectors
		;	If ($aCards[0] == 'A' And $aCards[1] == '2') Or ($aCards[0] == '2' And $aCards[1] == 'A') Or ($aCards[0] == '2' And $aCards[1] == '3') Or ($aCards[0] == '3' And $aCards[1] == '2') Or ($aCards[0] == '3' And $aCards[1] == '4') Or ($aCards[0] == '4' And $aCards[1] == '3') Or ($aCards[0] == '4' And $aCards[1] == '5') Or ($aCards[0] == '5' And $aCards[1] == '4') Or ($aCards[0] == '5' And $aCards[1] == '6') Or ($aCards[0] == '6' And $aCards[1] == '5') Or ($aCards[0] == '6' And $aCards[1] == '7') Or ($aCards[0] == '7' And $aCards[1] == '6') Or ($aCards[0] == '7' And $aCards[1] == '8') Or ($aCards[0] == '8' And $aCards[1] == '7') Or ($aCards[0] == '8' And $aCards[1] == '9') Or ($aCards[0] == '9' And $aCards[1] == '8') Or ($aCards[0] == '9' And $aCards[1] == 'T') Or ($aCards[0] == 'T' And $aCards[1] == '9') Or ($aCards[0] == 'T' And $aCards[1] == 'J') Or ($aCards[0] == 'J' And $aCards[1] == 'T') Or ($aCards[0] == 'J' And $aCards[1] == 'Q') Or ($aCards[0] == 'Q' And $aCards[1] == 'J') Or ($aCards[0] == 'Q' And $aCards[1] == 'K') Or ($aCards[0] == 'K' And $aCards[1] == 'Q') Or ($aCards[0] == 'K' And $aCards[1] == 'A') Or ($aCards[0] == 'A' And $aCards[1] == 'K') Then
		;		_Log('OK - connectors')
		;		$bCalled = True
		;	EndIf
		;EndIf
		
		;; combo
		;If $aSuits[0] == $aSuits[1] Then ; suited
		;	If $aCards[0] == 'A' Or $aCards[1] == 'A' Or $aCards[0] == 'K' Or $aCards[1] == 'K' Then ; one card is an A or K
		;		_Log('OK - A high suited')
		;		$bCalled = True
		;	EndIf
		;EndIf
		
	EndIf

	;
	; decide how much to raise
	;	
	If $aActionCount[1] Or $bGoAllIn Then ; someone raised or we have a sweet hand
		; lets go all in
		$iRaise = $iBlind * 1000
	Else 
		; 4xBB + (1xBB x # of callers)
		$iRaise = $iBlind * (4 + $aActionCount[2] + $aActionCount[0])
	EndIf

	;
	; lets do it !
	;	
	If $bRaised Or $bGoAllIn Then
		$iCashChange = True
		_Log('OK - Raise')
		_ToolTip($sDebug,'Raise')
		_PlayTurnRaise($iRaise, 'any')
	ElseIf $bCalled Then
		_Log('OK - Call')
		_ToolTip($sDebug,'Call')
		_PlayTurnCall('any')
	Else
		_Log('OK - Check')
		_ToolTip($sDebug,'Check')
		_PlayTurnCheck()
	EndIf

EndFunc

Func ShortStack_GAME($iSeat,$sHand)
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

	;
	; decide if we will go all in
	;
	
	; bot has already raised and has cash in the game
	If $iScore>=0.5 And ($bRaised or $bGoAllIn) Then
		$iCashChange = True
		_Log('OK - Raise')
		_ToolTip($sDebug,'Raise')
		_PlayTurnRaise($iBlind*1000, 'any')
		
	; bot has only checked until now, so play a little tighter
	ElseIf $iScore>=0.75 Then
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

