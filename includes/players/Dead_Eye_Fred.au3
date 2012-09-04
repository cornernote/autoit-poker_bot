;=================================================================
; Short Stack
;=================================================================
;#include <Array.au3>
#include <String.au3>
#include-once
Global $iMinBlind = Int(IniRead(@ScriptDir & "\settings.ini", "Table", "table_min_blind", 1))
Global $iMaxBlind = Int(IniRead(@ScriptDir & "\settings.ini", "Table", "table_max_blind", 2000000))
Global $iMinPlayers = Int(IniRead(@ScriptDir & "\settings.ini", "Table", "table_min_players", 6))
Global $xamount = IniRead(@ScriptDir & "\Dead_Eye_Fred.ini", "call", "preflopcallamount", "Doh")
Global $xamountriver = IniRead(@ScriptDir & "\Dead_Eye_Fred.ini", "call", "flopcallamount", "Doh")
Global $yamountriver = IniRead(@ScriptDir & "\Dead_Eye_Fred.ini", "call", "turncallamount", "Doh")
Global $zamountriver = IniRead(@ScriptDir & "\Dead_Eye_Fred.ini", "call", "rivercallamount", "Doh")
Global $ramount = IniRead(@ScriptDir & "\Dead_Eye_Fred.ini", "raise", "preflopraiseamount", "Doh")
Global $framount = IniRead(@ScriptDir & "\Dead_Eye_Fred.ini", "raise", "flopraiseamount", "Doh")
Global $tramount = IniRead(@ScriptDir & "\Dead_Eye_Fred.ini", "raise", "turnraiseamount", "Doh")
Global $rramount = IniRead(@ScriptDir & "\Dead_Eye_Fred.ini", "raise", "riverraiseamount", "Doh")
Global $highBank = IniRead(@ScriptDir & "\Dead_Eye_Fred.ini", "ForceBank", "high", "Doh")
Global $lowBank = IniRead(@ScriptDir & "\Dead_Eye_Fred.ini", "ForceBank", "low", "Doh")
Global $iLobby = IniRead(@ScriptDir & "\Dead_Eye_Fred.ini", "ForceNewRoom", "hands", "Doh")
Global $stay_longer = IniRead(@ScriptDir & "\Dead_Eye_Fred.ini", "ForceNewRoom", "staylonger", "Doh")
Global $iSuit_raise = IniRead(@ScriptDir & "\Dead_Eye_Fred.ini", "Suited_score_adjust", "raise", "Doh")
Global $iSuit_any = IniRead(@ScriptDir & "\Dead_Eye_Fred.ini", "Suited_score_adjust", "call_any", "Doh")
Global $iSuit_upto = IniRead(@ScriptDir & "\Dead_Eye_Fred.ini", "Suited_score_adjust", "call_upto", "Doh")
Global $iSuit_once = IniRead(@ScriptDir & "\Dead_Eye_Fred.ini", "Suited_score_adjust", "call_once", "Doh")
Global $iHand_raise = IniRead(@ScriptDir & "\Dead_Eye_Fred.ini", "Preflop_score_adjust", "raise", "Doh")
Global $iHand_any = IniRead(@ScriptDir & "\Dead_Eye_Fred.ini", "Preflop_score_adjust", "call_any", "Doh")
Global $iHand_upto = IniRead(@ScriptDir & "\Dead_Eye_Fred.ini", "Preflop_score_adjust", "call_upto", "Doh")
Global $iHand_once = IniRead(@ScriptDir & "\Dead_Eye_Fred.ini", "Preflop_score_adjust", "call_once", "Doh")
Global $sRounds = 0
Global $Banked = False ;Fixed banking on joining room
Global $sLobby = 0 ;force new room
Global $iWin = 0
Global $iBlind = 0
Global $bRaised = False
Global $bChecked = False
Global $bCalled = False
Global $bGoAllIn = False
Global $cRaised = False
Global $cChecked = False
Global $cCalled = False
Global $cGoAllIn = False
Global $bForceBank = False
Global $iStuck = 0
Global $iCashChange = False
Global $xCalled = False
Global $yCalled = False
Global $sReraise = False
Global $aLobby = 0
Global $zScore = 0
Global $camount = 0
Global $samount = 0 
Global $damount = 0 
Global $eamount = 0 
Global $famount = 0 
Global $amount = 0 
Global $iamount = 0 
Global $iScore = 0
Global $gScore = 0
Global $iLoop = 0
Global $tHands = 0
Global $aAllIns = 0 ;for toolbar allins
Global $bAllIns = 0 ;for toolbar allins
Global $cAllIns = False ;for toolbar allins
Global $bWins = 0 ;for toolbar wins
Global $cWon = False
Global $pWon = 0 ;% won
Global $bLose = 0 ;for toolbar loses
Global $aRaises = 0 
Global $bRaises = 0 
Global $aCall_anys = 0 
Global $bCall_anys = 0 
Global $aCall_onces = 0 
Global $bCall_onces = 0 
Global $aCall_uptos = 0 
Global $bCall_uptos = 0 
Global $aFolds = 0 
Global $bFolds = 0 
Global $samount_call = False
Global $add_round = 0
Global $CurrentChips = 0 
Global $StartChips = 0
Global $iChips = 0
Global $Profit = 0
Global $just_banked = 0 
Global $just_banked_high = 0
Global $just_banked_low = 0 
Global $since_last_bank = 0
Global $since_last_bank2 = 0
Global $went_all_in_amount = 0
Global $after_went_all_in_amount = 0
Global $GetRoomChips = True
Global $stay_longer_count = False
Global $RoomChips = 0
Global $room_profit = 0




Func Dead_Eye_Fred()
	If $iBlind == 0 Then
		$iBlind = _Blind()
	EndIf
	$iSeat = _Seat()
	$sHand = _Cards($iSeat)
	$sStreet = _Street($sHand)
	_HandHistory($sHand)
	If $StartChips == 0 Then
		$StartChips = _totalchips()
	ElseIf $StartChips > 0 Then
		$StartChips = $StartChips
	EndIf
	If $GetRoomChips Then
		$RoomChips = _totalchips()
		$GetRoomChips = False
		$add_round = 0
	EndIf
	If $bForceBank Then ;Fixed banking on joining room
		$bForceBank = False
		$Banked = False
	ElseIf $sStreet == 'NOGAME' Then
		_Log('OK - nogame')
		$iStuck = $iStuck + 1
		Dead_Eye_Fred_NOGAME($iSeat, $sHand)
	ElseIf $sStreet == 'PREFLOP' Then
		_Log('OK - preflop')
		$iStuck = 0
		Dead_Eye_Fred_PREFLOP($iSeat, $sHand)
	ElseIf $sStreet == 'FLOP' Then
		_Log('OK - flop')
		$iStuck = 0
		Dead_Eye_Fred_FLOP($iSeat, $sHand)
	ElseIf $sStreet == 'TURN' Then
		_Log('OK - turn')
		$iStuck = 0
		Dead_Eye_Fred_TURN($iSeat, $sHand)
	ElseIf $sStreet == 'RIVER' Then 
		_Log('OK - river')
		$iStuck = 0
		Dead_Eye_Fred_RIVER($iSeat, $sHand)
	EndIf
EndFunc   ;==>Dead_Eye_Fred

Func Dead_Eye_Fred_NOGAME($iSeat, $sHand)
	$iSeat = _Seat()
	$sHand = _Cards($iSeat)
	$sStreet = _Street($sHand)
	$iButton = _Button()
	$iPosition = _ButtonSeat($iSeat) + 1
	$iOpponents = _OpponentCount()
	$aActionCount = _ActionCount()
	$sStreet = _Street($sHand)
	$CurrentChips = _totalchips()
	$sLobby = ($iLobby - $sRounds + $add_round)
	$Profit = ((Int($CurrentChips)) - (Int($StartChips)))
	$just_banked_high = ($highBank * $iBlind)
	$just_banked_low = ($lowBank * $iBlind)
	$room_profit = ((Int($RoomChips)) - (Int($CurrentChips)))
	$room_profit2 = ((Int($CurrentChips)) - (Int($RoomChips)))
	$since_last_bank = ((Int($just_banked)) - (Int($CurrentChips)))
	$since_last_bank2 = ((Int($CurrentChips)) - (Int($just_banked)))
	$sDebug = 'Hand: ' & $sHand & @CRLF & 'Preflop Calling - All Ins: ' & $bAllIns & ' (W: ' & $bWins & ' L: ' & $bLose & ')'& @CRLF & 'Raise: ' & $bRaises & ' Any: ' & $bCall_anys & ' Once: ' & $bCall_onces & ' UpTo: ' & $bCall_uptos & ' Fold: ' & $bFolds & @CRLF & 'Total Hands: ' & $tHands & ' Startin Chips: ' & (Int($StartChips)) & @CRLF & 'Room Hands: ' & $sRounds & ' Til New Room: ' & $sLobby & @CRLF & 'Position: ' & $iPosition & @CRLF & 'Players: ' & $iOpponents & @CRLF & _ActionString($aActionCount)
	;$sDebug = 'Hand: ' & $sHand & @CRLF & 'Preflop Calling - All Ins: ' & $bAllIns & ' (W: ' & $bWins & ' L: ' & $bLose & ')'& @CRLF & 'Raise: ' & $bRaises & ' Any: ' & $bCall_anys & ' Once: ' & $bCall_onces & ' UpTo: ' & $bCall_uptos & ' Fold: ' & $bFolds & @CRLF & 'Total Hands: ' & $tHands & ' Startin Chips: ' & (Int($StartChips)) & @CRLF & 'Room Hands: ' & $sRounds & ' Til New Room: ' & $sLobby & @CRLF & 'Til Bank - Hands: ' & $sBank & ' All ins: ' & $inBank & ' Raises: ' & $raBank & @CRLF & 'Position: ' & $iPosition & @CRLF & 'Players: ' & $iOpponents
	$samount = 0 
	$zScore = 0
	$iScore = 0
	$gScore = 0
	;_Log('OK - $iSeat = ' & $iSeat)
	_Log('OK (no game) - $sHand = ' & $sHand)
	;_Log('OK - $iBlind = ' & $iBlind)
	;_Log('OK - $iButton = ' & $iButton)
	;_Log('OK - $iPosition = ' & $iPosition)
	;_Log('OK - $iOpponents = ' & $iOpponents)
	_Log('OK (no game) - $aActionCount = ' & _ActionString($aActionCount))
	_Log('OK (no game) - $iScore = ' & $iScore)
	_Log('OK (no game) - $gScore = ' & $gScore)
	
	If $Profit > 0 And $room_profit2 > 0 And $since_last_bank2 > 0 Then
		TrayTip("Z-Bot's Happy","Total Profits up " & ($Profit) & "." & @CRLF & "Room Profit up " & ($room_profit2) & "." & @CRLF & "Since Last Bank up " & ($since_last_bank2) & ".", 5, 1)
	ElseIf $Profit < 0 And $room_profit > 0 And $since_last_bank > 0 Then
		TrayTip("Z-Bot's Sad","Total Profits down " & ($Profit)& "." & @CRLF & "Room Profit down " & ($room_profit2) & "." & @CRLF & "Since Last Bank down " & ($since_last_bank2) & ".", 5, 1)
	ElseIf $Profit > 0 And $room_profit2 > 0 And $since_last_bank > 0 Then
		TrayTip("Z-Bot's Happy","Total Profits up " & ($Profit)& "." & @CRLF & "Room Profit up " & ($room_profit2) & "." & @CRLF & "Since Last Bank down " & ($since_last_bank2) & ".", 5, 1)
	ElseIf $Profit < 0 And $room_profit2 > 0 And $since_last_bank2 > 0 Then
		TrayTip("Z-Bot's Sad","Total Profits down " & ($Profit)& "." & @CRLF & "Room Profit up " & ($room_profit2) & "." & @CRLF & "Since Last Bank up " & ($since_last_bank2) & ".", 5, 1)
	ElseIf $Profit > 0 And $room_profit > 0 And $since_last_bank2 > 0 Then
		TrayTip("Z-Bot's Happy","Total Profits up " & ($Profit)& "." & @CRLF & "Room Profit down " & ($room_profit2) & "." & @CRLF & "Since Last Bank up " & ($since_last_bank2) & ".", 5, 1)
	ElseIf $Profit < 0 And $room_profit2 > 0 And $since_last_bank > 0 Then
		TrayTip("Z-Bot's Sad","Total Profits down " & ($Profit)& "." & @CRLF & "Room Profit up " & ($room_profit2) & "." & @CRLF & "Since Last Bank down " & ($since_last_bank2) & ".", 5, 1)
	ElseIf $Profit < 0 And $room_profit > 0 And $since_last_bank2 > 0 Then
		TrayTip("Z-Bot's Sad","Total Profits down " & ($Profit)& "." & @CRLF & "Room Profit down " & ($room_profit2) & "." & @CRLF & "Since Last Bank up " & ($since_last_bank2) & ".", 5, 1)
	ElseIf $Profit > 0 And $room_profit > 0 And $since_last_bank > 0 Then
		TrayTip("Z-Bot's Happy","Total Profits up " & ($Profit)& "." & @CRLF & "Room Profit down " & ($room_profit2) & "." & @CRLF & "Since Last Bank down " & ($since_last_bank2) & ".", 5, 1)
	EndIf
	
	If $sStreet == 'PREFLOP' Then
		_Log('OK - preflop')
		$iStuck = 0
		Dead_Eye_Fred_PREFLOP($iSeat, $sHand)
	EndIf
	
	If $iBlind == 0 Then
		$iBlind = _Blind()
	EndIf
	
	If $sRounds = 0 And Not $Banked Then ;Fixed banking on joining room
		$iCashChange = True 
		$Banked = True
	EndIf
	
	If $aActionCount[5] Then
		$iNoGameCount = $iNoGameCount - 1
		If $iNoGameCount < 1 Then 
			$iNoGameCount = 100
		EndIf
		$zScore = 0
		$iScore = 0
		$gScore = 0
		$samount = 0 
		;$iNoGameCount = $iNoGameCount - 1
		$iNoGameReason = 'someone won'
		_Log('OK - waiting because someone won')
		;_ToolTip('someone won', 'Waiting')
		; check number of players
		If $iWin >= 1 Then
			$sRounds = $sRounds + 1 ;hands played in room
			$tHands = $tHands + 1 ; total hands played
			$iWin = 0
			If $aAllIns >= 1 Then ; for tooltip allin amount
				$bAllIns = $bAllIns + 1 ;keeps all in count
				$cAllIns = True
				$aAllIns = 0
			ElseIf $aRaises >= 1 Then
				$bRaises = $bRaises + 1
				$aRaises = 0
			ElseIf $aCall_anys >= 1 Then
				$bCall_anys = $bCall_anys + 1
				$aCall_anys = 0
			ElseIf $aCall_uptos >= 1 Then
				$bCall_uptos = $bCall_uptos + 1
				$aCall_uptos = 0
				$aFolds = 0 
			ElseIf $aFolds >= 1 Then
				$bFolds = $bFolds + 1
				$aFolds = 0 
				$aCall_onces = 0
			ElseIf $aCall_onces >= 1 Then
				$bCall_onces = $bCall_onces + 1
				$aCall_onces = 0
			EndIf
		EndIf
		If $stay_longer_count And $room_profit2 > 0 Then ;Stay Longer in room?
				$add_round = $add_round + 1	
				$stay_longer_count = False
		EndIf
		If $sStreet == 'PREFLOP' Then
			_Log('OK - preflop')
			$iStuck = 0
			Dead_Eye_Fred_PREFLOP($iSeat, $sHand)
		EndIf
		$aLobby = $aLobby + 1
		If $aLobby = 10 Then
			_PopupClose()
		EndIf
		If $aLobby > 100 And $iMinPlayers > 1 Then
			_ToolTip('No empty seat found 100 times, joining new room.','Warning')
			_TableStand()
			_Lobby()
			_PopupClose()
			$aLobby = 0
			Return
		EndIf
		Sleep(1000)
		_ToolTip($iNoGameReason & @CRLF & 'paused ' & $iNoGameCount, 'Waiting')
		;Return
	EndIf
	
	If $iNoGameCount <= 0 And Not $aActionCount[5] Then
		; check blind size
		If $iBlind == 0 Then
			_Log('WARNING - blinds could not be read')
			_ToolTip('blinds could not be read', 'Bad Room')
			_TableStand()
			_Lobby()
			Return
		EndIf

		If $iBlind < $iMinBlind Then
			_Log('WARNING - blinds too small (' & $iBlind & ')')
			_ToolTip('blinds too small (' & $iBlind & '), going to lobby', 'Bad Room')
			_TableStand()
			_Lobby()
			Return
		EndIf
		If $iBlind > $iMaxBlind Then
			_Log('WARNING - blinds too high (' & $iBlind & ')')
			_ToolTip('blinds too high (' & $iBlind & '), going to lobby', 'Bad Room')		
			_TableStand()
			_Lobby()
			Return
		EndIf
		; check number of players
		If (9 - _SeatCountEmpty()) < $iMinPlayers Then
			_Log('WARNING - not enough players')
			_ToolTip('not enough players, going to lobby', 'Bad Room')
			$sRounds = 0
			_TableStand()
			_Lobby()
			Return
		EndIf
		; bank if needed
		If $iCashChange And Not $aActionCount[5] Then
			_Log('OK - banking')
			_ToolTip('Needed to bank', 'Banking')
			_TableBank()
			Return
		EndIf
		If $sLobby <= 0 Then ; force new room
			_ToolTip('Forcing New Room', 'Room Change')
			$sRounds = 0
			_TableStand()
			_Lobby()
			Return
		EndIf
		If $aLobby = 5 Then
			_PopupClose()
		EndIf
		If $aLobby > 100 Then
			_ToolTip('No empty seat found 100 times, joining new room.','Warning')
			_TableStand()
			_Lobby()
			_PopupClose()
			$aLobby = 0
			Return
		EndIf
		_Chat()
		_ToolTip($sDebug, 'No Game')
		;Return


	; decrement the wait timer
	ElseIf $iNoGameCount > 0 Then
		_Log('OK - paused ' & $iNoGameCount)
		$iNoGameCount = $iNoGameCount - 1
		If $iWin >= 1 Then
			$sRounds = $sRounds + 1 ;hands played in room
			$tHands = $tHands + 1 ; total hands played
			$iWin = 0
			If $aAllIns >= 1 Then ; for tooltip allin amount
				$bAllIns = $bAllIns + 1 ;keeps all in count
				$cAllIns = True
				$aAllIns = 0
			ElseIf $aRaises >= 1 Then
				$bRaises = $bRaises + 1
				$aRaises = 0
			ElseIf $aCall_anys >= 1 Then
				$bCall_anys = $bCall_anys + 1
				$aCall_anys = 0
			ElseIf $aCall_uptos >= 1 Then
				$bCall_uptos = $bCall_uptos + 1
				$aCall_uptos = 0
				$aFolds = 0 
			ElseIf $aFolds >= 1 Then
				$bFolds = $bFolds + 1
				$aFolds = 0 
				$aCall_onces = 0
			ElseIf $aCall_onces >= 1 Then
				$bCall_onces = $bCall_onces + 1
				$aCall_onces = 0
			EndIf
		EndIf
		If $stay_longer_count And $room_profit2 > 0 Then ;Stay Longer in room?
				$add_round = $add_round + 1	
				$stay_longer_count = False
		EndIf
		$samount_call = False
		Sleep(1000)
		_ToolTip($iNoGameReason & @CRLF & 'paused ' & $iNoGameCount, 'Waiting')
	EndIf
EndFunc   ;==>Dead_Eye_Fred_NOGAME

Func Dead_Eye_Fred_PREFLOP($iSeat, $sHand)
	$aLobby = 0
	$iScore = 0
	$gScore = 0
	$aCards = _CardNumbersArray($sHand)
	$aSuits = _CardSuitsArray($sHand)
	$iOpponents = _OpponentCount()
	$iNoGameCount = 1
	$iNoGameReason = 'Fold on Preflop'
	$iButton = _Button()
	$iPosition = _ButtonSeat($iSeat) + 1
	$aActionCount = _ActionCount()
	$after_went_all_in_amount = _totalchips()
	$iSeat = _Seat()
	$sHand = _Cards($iSeat)
	$sStreet = _Street($sHand)
	$camount = $xamount * $iBlind
	$sDebug = 'Hand: ' & $sHand & @CRLF & 'Call Amt: ' & $camount & @CRLF & 'Called Amt: ' & $samount & @CRLF & 'Banking: ' & $iCashChange & @CRLF & _ActionString($aActionCount)
	$sholes = String($aCards[0] & $aCards[1])
	$sholes2 = String($aCards[1] & $aCards[0])
	$sAll_in = IniRead(@ScriptDir & "\Dead_Eye_Fred.ini", "Preflop_Hands", "all_in", "Doh")
	$sRaise = IniRead(@ScriptDir & "\Dead_Eye_Fred.ini", "Preflop_Hands", "raise", "Doh")
	$sCall = IniRead(@ScriptDir & "\Dead_Eye_Fred.ini", "Preflop_Hands", "call_any", "Doh")
	$sCallo = IniRead(@ScriptDir & "\Dead_Eye_Fred.ini", "Preflop_Hands", "call_once", "Doh")
	$sCheck = IniRead(@ScriptDir & "\Dead_Eye_Fred.ini", "Preflop_Hands", "call_upto", "Doh")
	$dAll_in = IniRead(@ScriptDir & "\Dead_Eye_Fred.ini", "Suited_Hands", "all_in", "Doh")
	$dRaise = IniRead(@ScriptDir & "\Dead_Eye_Fred.ini", "Suited_Hands", "raise", "Doh")
	$dCall = IniRead(@ScriptDir & "\Dead_Eye_Fred.ini", "Suited_Hands", "call_any", "Doh")
	$dCallo = IniRead(@ScriptDir & "\Dead_Eye_Fred.ini", "Suited_Hands", "call_once", "Doh")
	$dCheck = IniRead(@ScriptDir & "\Dead_Eye_Fred.ini", "Suited_Hands", "call_upto", "Doh")
	$aAll_in = StringSplit($sAll_in, " ", 2)
	$aRaise = StringSplit($sRaise, " ", 2)
	$aCall = StringSplit($sCall, " ", 2)
	$aCallo = StringSplit($sCallo, " ", 2)
	$aCheck = StringSplit($sCheck, " ", 2)
	$fAll_in = StringSplit($dAll_in, " ", 2)
	$fRaise = StringSplit($dRaise, " ", 2)
	$fCall = StringSplit($dCall, " ", 2)
	$fCallo = StringSplit($dCallo, " ", 2)
	$fCheck = StringSplit($dCheck, " ", 2)
	;_Log('OK - $iSeat = ' & $iSeat)
	_Log('OK (preflop) - $sHand = ' & $sHand)
	;_Log('OK - $iBlind = ' & $iBlind)
	;_Log('OK - $iButton = ' & $iButton)
	;_Log('OK - $iPosition = ' & $iPosition)
	;_Log('OK - $iOpponents = ' & $iOpponents)
	_Log('OK (preflop) - $aActionCount = ' & _ActionString($aActionCount))
	_Log('OK (preflop) - $iScore = ' & $iScore)
	_Log('OK (preflop) - $gScore = ' & $gScore)

	; reset decisions
	$bChecked = False
	$bCalled = False
	$bCalledo = False
	$bRaised = False
	$bGoAllIn = False
	$cChecked = False
	$cCalled = False
	$cCalledo = False
	$cRaised = False
	$cGoAllIn = False
	$damount = 0 
	$eamount = 0 
	$famount = 0 

	If $sStreet == 'FLOP' Then
		_Log('OK - flop')
		$iStuck = 0
		Dead_Eye_Fred_FLOP($iSeat, $sHand)
	EndIf
	
	If $since_last_bank >= $just_banked_low Or $since_last_bank2 >= $just_banked_high Then  ;bank or not
		$iCashChange = True
	EndIf
	
	If (Int($after_went_all_in_amount)) > (Int($went_all_in_amount)) Then ;did we win an all in
		$cWon = True
	Else 
		$cWon = False
	EndIf
	
	If $cAllIns Then ;more of the did we win
		If Not $cWon Then ; we lost
			$bLose = $bLose + 1
		Else 
			$bWins = $bWins + 1 ;we won
		EndIf
		$cAllIns = False
	EndIf
	
	If $stay_longer = 1 Then
		$stay_longer_count = True
	Else 
		$stay_longer_count = False
	EndIf
	
	If $samount_call Then
		$samount = $iBlind ;called amount = blind
	EndIf
			; suited
	If ($aSuits[0] == $aSuits[1]) Then
		For $i = 0 To UBound($fAll_in) - 1
			If $sholes = $fAll_in[$i] Or $sholes2 = $fAll_in[$i] Then
				;_Log('OK - ' & $sholes)
				$cGoAllIn = True
				;$zScore = 0
			EndIf
		Next

		For $i = 0 To UBound($fRaise) - 1
			If $sholes = $fRaise[$i] Or $sholes2 = $fRaise[$i] Then
				;_Log('OK - ' & $sholes)
				$cRaised = True
				;$zScore = $iSuit_raise
			EndIf
		Next

		For $i = 0 To UBound($fCall) - 1
			If $sholes = $fCall[$i] Or $sholes2 = $fCall[$i] Then ;call_any
				;_Log('OK - ' & $sholes)
				$cCalled = True
				;$zScore = $iSuit_any
			EndIf
		Next
		
		For $i = 0 To UBound($fCallo) - 1
			If $sholes = $fCallo[$i] Or $sholes2 = $fCallo[$i] Then ;call_once
				;_Log('OK - ' & $sholes)
				$cCalledo = True
				;$zScore = $iSuit_once
			EndIf
		Next
	
		For $i = 0 To UBound($fCheck) - 1
			If $sholes = $fCheck[$i] Or $sholes2 = $fCheck[$i] Then ;call_upto
				;_Log('OK - ' & $sholes)
				$cChecked = True
				;$zScore = $iSuit_upto
			EndIf
		Next
		
	ElseIf Not ($aSuits[0] == $aSuits[1]) Then
		For $i = 0 To UBound($aAll_in) - 1
			If $sholes = $aAll_in[$i] Or $sholes2 = $aAll_in[$i] Then
				;_Log('OK - ' & $sholes)
				$bGoAllIn = True
				;$zScore = 0
			EndIf
		Next

		For $i = 0 To UBound($aRaise) - 1
			If $sholes = $aRaise[$i] Or $sholes2 = $aRaise[$i] Then
				;_Log('OK - ' & $sholes)
				$bRaised = True
				;$zScore = $iHand_raise
			EndIf
		Next

		For $i = 0 To UBound($aCall) - 1
			If $sholes = $aCall[$i] Or $sholes2 = $aCall[$i] Then ;call_any
				;_Log('OK - ' & $sholes)
				$bCalled = True
				;$zScore = $iHand_any
			EndIf
		Next
		
		For $i = 0 To UBound($aCallo) - 1
			If $sholes = $aCallo[$i] Or $sholes2 = $aCallo[$i] Then ;call_once
				;_Log('OK - ' & $sholes)
				$bCalledo = True
				;$zScore = $iHand_once
			EndIf
		Next
	
		For $i = 0 To UBound($aCheck) - 1
			If $sholes = $aCheck[$i] Or $sholes2 = $aCheck[$i] Then ;call_upto
				;_Log('OK - ' & $sholes)
				$bChecked = True
				;$zScore = $iHand_upto
			EndIf
		Next
	EndIf
	
	If $aActionCount[1] Or $bGoAllIn Or $cGoAllIn Then ; someone raised or we have a sweet hand
		$iRaise = $iBlind * 100
		$iWin = $iWin + 1
	ElseIf $sReraise Then
		$iRaise = $iBlind * 100
		$sReraise = False
	Else
		$iRaise = $iBlind * $ramount
		$iWin = $iWin + 1
	EndIf

	;just for tooltip
	If $bCalledo And $aActionCount[0] =0 And $aActionCount[1] =0 Or $cCalledo And $aActionCount[0] =0 And $aActionCount[1] =0 Then
		If $cCalledo And $aActionCount[0] =0 And $aActionCount[1] =0 Then
			;_Log('OK - Suited - Call_Once')
			_ToolTip($sDebug, 'Suited - Call_Once')
		ElseIf $bCalledo And $aActionCount[0] =0 And $aActionCount[1] =0 Then
			;_Log('OK - Call_Once')
			_ToolTip($sDebug, 'Call_Once')
		EndIf
		
	ElseIf $bChecked Or $cChecked Then
		If $cChecked Then
			;_Log('OK - Suited - Call_UpTo')
			_ToolTip($sDebug, 'Suited - Call_UpTo')
		ElseIf $bChecked Then
			;_Log('OK - Call_UpTo')
			_ToolTip($sDebug, 'Call_UpTo')
		EndIf
		
	ElseIf $bGoAllIn Or $cGoAllIn Then
		If $cGoAllIn Then
			;_Log('OK - Suited - All In')
			_ToolTip($sDebug, 'All In')
		ElseIf $bGoAllIn Then
			;_Log('OK - All In')
			_ToolTip($sDebug, 'All In')
		EndIf
		
	ElseIf $bRaised Or $cRaised Then
		If $cRaised And $aActionCount[1] =0 And $aActionCount[0] =0 Then
			;_Log('OK - Suited - Raise')
			_ToolTip($sDebug, 'Suited - Raise')
		ElseIf $bRaised And $aActionCount[1] =0 And $aActionCount[0] =0 Then
			;_Log('OK - Raise')
			_ToolTip($sDebug, 'Raise')
		Else 
			;_Log('OK - Raised - Calling Any')
			_ToolTip($sDebug, 'Raised - Calling Any')
		EndIf
		
		
	ElseIf $bCalled Or $cCalled Then
		If $cCalled Then
			;_Log('OK - Suited - Call_Any')
			_ToolTip($sDebug, 'Suited - Call_Any')
		ElseIf $bCalled Then
			;_Log('OK - Call_Any')
			_ToolTip($sDebug, 'Call_Any')
		EndIf
		
	Else
		;_Log('OK - Check/Fold')
		_ToolTip($sDebug, 'Check/Fold')
	EndIf
	
	; lets do it...the real thing
	
	
	If _MyTurn() And $sStreet == 'PREFLOP' Then
		$sDebug = 'Hand: ' & $sHand & @CRLF & 'Call Amt: ' & $camount & @CRLF & 'Called Amt: ' & $samount & @CRLF & 'Banking: ' & $iCashChange & @CRLF & _ActionString($aActionCount)
		If ($aSuits[0] == $aSuits[1]) And $sStreet == 'PREFLOP' Then
			For $i = 0 To UBound($fAll_in) - 1
				If $sholes = $fAll_in[$i] Or $sholes2 = $fAll_in[$i] Then
					_Log('OK - ' & $sholes)
					$cGoAllIn = True
					$zScore = 0
				EndIf
			Next

			For $i = 0 To UBound($fRaise) - 1
				If $sholes = $fRaise[$i] Or $sholes2 = $fRaise[$i] Then
					_Log('OK - ' & $sholes)
					$cRaised = True
					$zScore = $iSuit_raise
				EndIf
			Next

			For $i = 0 To UBound($fCall) - 1
				If $sholes = $fCall[$i] Or $sholes2 = $fCall[$i] Then ;call_any
					_Log('OK - ' & $sholes)
					$cCalled = True
					$zScore = $iSuit_any
				EndIf
			Next
		
			For $i = 0 To UBound($fCallo) - 1
				If $sholes = $fCallo[$i] Or $sholes2 = $fCallo[$i] Then ;call_once
					_Log('OK - ' & $sholes)
					$cCalledo = True
					$zScore = $iSuit_once
				EndIf
			Next
	
			For $i = 0 To UBound($fCheck) - 1
				If $sholes = $fCheck[$i] Or $sholes2 = $fCheck[$i] Then ;call_upto
					_Log('OK - ' & $sholes)
					$cChecked = True
					$zScore = $iSuit_upto				
				EndIf
			Next
		
		ElseIf Not ($aSuits[0] == $aSuits[1]) Then
			For $i = 0 To UBound($aAll_in) - 1
				If $sholes = $aAll_in[$i] Or $sholes2 = $aAll_in[$i] Then
					_Log('OK - ' & $sholes)
					$bGoAllIn = True
					$zScore = 0
				EndIf
			Next

			For $i = 0 To UBound($aRaise) - 1
				If $sholes = $aRaise[$i] Or $sholes2 = $aRaise[$i] Then
					_Log('OK - ' & $sholes)
					$bRaised = True
					$zScore = $iHand_raise
				EndIf
			Next

			For $i = 0 To UBound($aCall) - 1
				If $sholes = $aCall[$i] Or $sholes2 = $aCall[$i] Then ;call_any
					_Log('OK - ' & $sholes)
					$bCalled = True
					$zScore = $iHand_any
				EndIf
			Next
		
			For $i = 0 To UBound($aCallo) - 1
				If $sholes = $aCallo[$i] Or $sholes2 = $aCallo[$i] Then ;call_once
					_Log('OK - ' & $sholes)
					$bCalledo = True
					$zScore = $iHand_once
				EndIf
			Next
	
			For $i = 0 To UBound($aCheck) - 1
				If $sholes = $aCheck[$i] Or $sholes2 = $aCheck[$i] Then ;call_upto
					_Log('OK - ' & $sholes)
					$bChecked = True
					$zScore = $iHand_upto
				EndIf
			Next
		Else
			$zScore = 0
		EndIf
		
		If $bCalledo And $aActionCount[0] =0 And $aActionCount[1] =0 Or $cCalledo And $aActionCount[0] =0 And $aActionCount[1] =0 Then
			$aCall_onces = $aCall_onces + 1 ; tooltip call_once amount
			If $cCalledo And $aActionCount[0] =0 And $aActionCount[1] =0 Then
				_Log('OK - Suited - Call_Once')
				_ToolTip($sDebug, 'Suited - Call_Once')
				_PlayTurnCall( 'any') ;changed
			ElseIf $bCalledo And $aActionCount[0] =0 And $aActionCount[1] =0 Then
				_Log('OK - Call_Once')
				_ToolTip($sDebug, 'Call_Once')
				_PlayTurnCall( 'any') ;changed
			EndIf
		
		ElseIf $bChecked Or $cChecked Then
			$aCall_uptos = $aCall_uptos + 1 ; tooltip call_upto amount
			If $cChecked Then
				_Log('OK - Suited - Call_UpTo')
				_ToolTip($sDebug, 'Suited - Call_UpTo')
				_PlayFredTurnCall($camount)
			ElseIf $bChecked Then
				_Log('OK - Call_UpTo')
				_ToolTip($sDebug, 'Call_UpTo')
				_PlayFredTurnCall($camount)
			EndIf
		
		ElseIf $bGoAllIn Or $cGoAllIn Then
			$went_all_in_amount = _totalchips()
			$aAllIns = $aAllIns + 1 ; tooltip allin amount
			If $cGoAllIn Then
				_Log('OK - Suited - All In')
				_ToolTip($sDebug, 'All In')
				_PlayTurnRaise($iBlind * 1000, 'any')
			ElseIf $bGoAllIn Then
				_Log('OK - All In')
				_ToolTip($sDebug, 'All In')
				_PlayTurnRaise($iBlind * 1000, 'any')
			EndIf
		
		ElseIf $bRaised Or $cRaised Then
			$aRaises = $aRaises + 1 ; tooltip raise amount
			If $cRaised And $aActionCount[1] =0 And $aActionCount[0] =0 Then
				_Log('OK - Suited - Raise')
				_ToolTip($sDebug, 'Suited - Raise')
				_PlayTurnRaise($iRaise, 'any')
			ElseIf $bRaised And $aActionCount[1] =0 And $aActionCount[0] =0 Then
				_Log('OK - Raise')
				_ToolTip($sDebug, 'Raise')
				_PlayTurnRaise($iRaise, 'any')
			Else 
				_Log('OK - Raised - Calling Any')
				_ToolTip($sDebug, 'Raised - Calling Any')
				_PlayTurnCall( 'any')
			EndIf
		
		
		ElseIf $bCalled Or $cCalled Then
			$aCall_anys = $aCall_anys + 1 ; tooltip call_any amount
			If $cCalled Then
				_Log('OK - Suited - Call_Any')
				_ToolTip($sDebug, 'Suited - Call_Any')
				_PlayTurnCall( 'any')
			ElseIf $bCalled Then
				_Log('OK - Call_Any')
				_ToolTip($sDebug, 'Call_Any')
				_PlayTurnCall( 'any')
			EndIf
		
		Else
			$aFolds = $aFolds + 1 ; tooltip fold amount
			_Log('OK - Check/Fold')
			_ToolTip($sDebug, 'Check/Fold')
			_PlayTurnCheck()
		EndIf
	EndIf
EndFunc   ;==>Dead_Eye_Fred_PREFLOP

Func Dead_Eye_Fred_FLOP($iSeat, $sHand)
	$aLobby = 0
	$camount = $xamountriver * $iBlind
	$sAction = IniReadSection(@ScriptDir & "\Dead_Eye_Fred.ini", "FlopScore")
	Local $aAction[UBound($sAction) - 1][3]
	$iNoGameReason = 'Folded on Flop'
	$iOpponents = _OpponentCount()
	$iNoGameCount = 50
	$iPosition = _ButtonSeat($iSeat) + 1
	$iButton = _Button()
	$aActionCount = _ActionCount()
	$iSeat = _Seat()
	$sHand = _Cards($iSeat)
	$sStreet = _Street($sHand)
	$iScore = _SimHandMulti($sHand, $iOpponents - 1) + ($zScore)
	If $iScore > 1.0 Then 
		$iScore = 1.0
	EndIf
	$sDebug = 'Hand: ' & $sHand & @CRLF & 'Score Adjustment: ' & $zScore & @CRLF &'Score: ' & $iScore & @CRLF & 'Flop Call Amt: ' & $camount & @CRLF & 'Called Amt: ' & $damount & @CRLF & 'Banking: ' & $iCashChange & @CRLF & 'Players: ' & $iOpponents & @CRLF & _ActionString($aActionCount)
		
	;_Log('OK - $iSeat = ' & $iSeat)
	_Log('OK (flop) - $sHand = ' & $sHand)
	;_Log('OK - $iBlind = ' & $iBlind)
	;_Log('OK - $iButton = ' & $iButton)
	;_Log('OK - $iPosition = ' & $iPosition)
	;_Log('OK - $iOpponents = ' & $iOpponents)
	_Log('OK (flop) - $aActionCount = ' & _ActionString($aActionCount))
	_Log('OK (flop) - $iScore = ' & $iScore)
	_Log('OK (flop) - Score Adj = ' & $zScore)
	
	If $sStreet == 'TURN' Then
		_Log('OK - turn')
		$iStuck = 0
		Dead_Eye_Fred_TURN($iSeat, $sHand)
	EndIf

	For $i = 1 To $sAction[0][0]
		$aTemp = StringSplit($sAction[$i][0], "-", 2)
		$aAction[$i - 1][0] = $aTemp[0]
		$aAction[$i - 1][1] = $aTemp[1]
		$aAction[$i - 1][2] = $sAction[$i][1]
	Next
	For $i = 0 To UBound($aAction) - 1
		If $iScore >= $aAction[$i][0] And $iScore <= $aAction[$i][1] Then
			$gScore = $aAction[$i][2]
		EndIf
	Next
	
	;For tooltip
	If $gScore = "all_in" Then
		;_Log('OK - All In')
		_ToolTip($sDebug, 'All In')
	ElseIf $gScore = "raise" And $aActionCount[1] =0 Then
		;_Log('OK - Raise')
		_ToolTip($sDebug, 'Raise')
	ElseIf $gScore = "raise" And $aActionCount[1] >0 Then
		;_Log('OK - Raised - Calling Any')
		_ToolTip($sDebug, 'Raised - Calling Any')
	ElseIf $gScore = "call_upto" Then	
		;_Log('OK - Call_UpTo')
		_ToolTip($sDebug, 'Call_UpTo')
	ElseIf $gScore = "call" Then
		;_Log('OK - Call')
		_ToolTip($sDebug, 'Call')
	Else
		;_Log('OK - Check/Fold')
		_ToolTip($sDebug, 'Check/Fold')
	EndIf
	
	;The real thing
	If _MyTurn() And $sStreet == 'FLOP' Then
		$sDebug = 'Hand: ' & $sHand & @CRLF & 'Score Adjustment: ' & $zScore & @CRLF &'Score: ' & $iScore & @CRLF & 'Flop Call Amt: ' & $camount & @CRLF & 'Called Amt: ' & $damount & @CRLF & 'Banking: ' & $iCashChange & @CRLF & 'Players: ' & $iOpponents & @CRLF & _ActionString($aActionCount)
		If $gScore = "all_in" Then
			_Log('OK - All In')
			_ToolTip($sDebug, 'All In')
			_PlayTurnRaise($iBlind * 1000, 'any')
		ElseIf $gScore = "raise" And $aActionCount[1] =0 Then
			_Log('OK - Raise')
			_ToolTip($sDebug, 'Raise')
			_PlayTurnRaise($iBlind * $framount, 'any')
		ElseIf $gScore = "raise" And $aActionCount[1] >0 Then
			_Log('OK - Raised - Calling Any')
			_ToolTip($sDebug, 'Raised - Calling Any')
			_PlayTurnCall( 'any')
		ElseIf $gScore = "call_upto" Then		
			_Log('OK - Call_UpTo')
			_ToolTip($sDebug, 'Call_UpTo')
			_PlayFredTurnCall2($camount)
		ElseIf $gScore = "call" Then
			_Log('OK - Call')
			_ToolTip($sDebug, 'Call')
			_PlayTurnCall( 'any')
		Else
			_Log('OK - Check/Fold')
			_ToolTip($sDebug, 'Check/Fold')
			_PlayTurnCheck()
		EndIf
	EndIf
EndFunc  ;==>Dead_Eye_Fred_GAME

Func Dead_Eye_Fred_TURN($iSeat, $sHand)
	$aLobby = 0
	$camount = $yamountriver * $iBlind
	$sAction = IniReadSection(@ScriptDir & "\Dead_Eye_Fred.ini", "TurnScore")
	Local $aAction[UBound($sAction) - 1][3]
	$iNoGameReason = 'Folded on Turn'
	$iOpponents = _OpponentCount()
	$iNoGameCount = 40
	$iPosition = _ButtonSeat($iSeat) + 1
	$iButton = _Button()
	$aActionCount = _ActionCount()
	$iSeat = _Seat()
	$sHand = _Cards($iSeat)
	$sStreet = _Street($sHand)
	$iScore = _SimHandMulti($sHand, $iOpponents - 1) + ($zScore)
	If $iScore > 1.0 Then 
		$iScore = 1.0
	EndIf
	$sDebug = 'Hand: ' & $sHand & @CRLF & 'Score Adjustment: ' & $zScore & @CRLF &'Score: ' & $iScore & @CRLF & 'Turn Call Amt: ' & $camount & @CRLF & 'Called Amt: ' & $eamount & @CRLF & 'Banking: ' & $iCashChange & @CRLF & 'Players: ' & $iOpponents & @CRLF & _ActionString($aActionCount)
	
	;_Log('OK - $iSeat = ' & $iSeat)
	_Log('OK (turn) - $sHand = ' & $sHand)
	;_Log('OK - $iBlind = ' & $iBlind)
	;_Log('OK - $iButton = ' & $iButton)
	;_Log('OK - $iPosition = ' & $iPosition)
	;_Log('OK - $iOpponents = ' & $iOpponents)
	_Log('OK (turn) - $aActionCount = ' & _ActionString($aActionCount))
	_Log('OK (turn) - $iScore = ' & $iScore)
	_Log('OK (turn) - Score Adj = ' & $zScore)
	
	If $sStreet == 'RIVER' Then 
		_Log('OK - river')
		$iStuck = 0
		Dead_Eye_Fred_RIVER($iSeat, $sHand)
	EndIf

	For $i = 1 To $sAction[0][0]
		$aTemp = StringSplit($sAction[$i][0], "-", 2)
		$aAction[$i - 1][0] = $aTemp[0]
		$aAction[$i - 1][1] = $aTemp[1]
		$aAction[$i - 1][2] = $sAction[$i][1]
	Next
	For $i = 0 To UBound($aAction) - 1
		If $iScore >= $aAction[$i][0] And $iScore <= $aAction[$i][1] Then
			$gScore = $aAction[$i][2]
		EndIf
	Next
	;for tooltip
	If $gScore = "all_in" Then
		;_Log('OK - All In')
		_ToolTip($sDebug, 'All In')
	ElseIf $gScore = "raise" And $aActionCount[1] =0 Then
		;_Log('OK - Raise')
		_ToolTip($sDebug, 'Raise')
	ElseIf $gScore = "raise" And $aActionCount[1] >0 Then
		;_Log('OK - Raised - Calling Any')
		_ToolTip($sDebug, 'Raised - Calling Any')
	ElseIf $gScore = "call_upto" Then		
		;_Log('OK - Call_UpTo')
		_ToolTip($sDebug, 'Call_UpTo')
	ElseIf $gScore = "call" Then
		;_Log('OK - Call')
		_ToolTip($sDebug, 'Call')
	Else
		;_Log('OK - Check/Fold')
		_ToolTip($sDebug, 'Check/Fold')
	EndIf
	
	;real thing
	If _MyTurn() And $sStreet == 'TURN' Then
		$sDebug = 'Hand: ' & $sHand & @CRLF & 'Score Adjustment: ' & $zScore & @CRLF &'Score: ' & $iScore & @CRLF & 'Turn Call Amt: ' & $camount & @CRLF & 'Called Amt: ' & $eamount & @CRLF & 'Banking: ' & $iCashChange & @CRLF & 'Players: ' & $iOpponents & @CRLF & _ActionString($aActionCount)
		If $gScore = "all_in" Then
			_Log('OK - All In')
			_ToolTip($sDebug, 'All In')
			_PlayTurnRaise($iBlind * 1000, 'any')
		ElseIf $gScore = "raise" And $aActionCount[1] =0 Then
			_Log('OK - Raise')
			_ToolTip($sDebug, 'Raise')
			_PlayTurnRaise($iBlind * $tramount, 'any')
		ElseIf $gScore = "raise" And $aActionCount[1] >0 Then
			_Log('OK - Raised - Calling Any')
			_ToolTip($sDebug, 'Raised - Calling Any')
			_PlayTurnCall( 'any')
		ElseIf $gScore = "call_upto" Then		
			_Log('OK - Call_UpTo')
			_ToolTip($sDebug, 'Call_UpTo')
			_PlayFredTurnCall3($camount)
		ElseIf $gScore = "call" Then
			_Log('OK - Call')
			_ToolTip($sDebug, 'Call')
			_PlayTurnCall( 'any')
		Else
			_Log('OK - Check/Fold')
			_ToolTip($sDebug, 'Check/Fold')
			_PlayTurnCheck()
		EndIf
	EndIf
EndFunc  ;==>Dead_Eye_Fred_GAME

Func Dead_Eye_Fred_RIVER($iSeat, $sHand)
	$aLobby = 0
	$zScore = 0
	$camount = $zamountriver * $iBlind
	$sAction = IniReadSection(@ScriptDir & "\Dead_Eye_Fred.ini", "RiverScore")
	Local $aAction[UBound($sAction) - 1][3]
	$iNoGameReason = 'Folded on River'
	$iOpponents = _OpponentCount()
	$iNoGameCount = 30
	$iPosition = _ButtonSeat($iSeat) + 1
	$iButton = _Button()
	$aActionCount = _ActionCount()
	$iSeat = _Seat()
	$sHand = _Cards($iSeat)
	$sStreet = _Street($sHand)
	$iScore = _SimHandMulti($sHand, $iOpponents - 1)
	$sDebug = 'Hand: ' & $sHand & @CRLF & 'Score Adjustment: ' & $zScore & @CRLF &'Score: ' & $iScore & @CRLF & 'River Call Amt: ' & $camount & @CRLF & 'Called Amt: ' & $famount & @CRLF & 'Banking: ' & $iCashChange & @CRLF & 'Players: ' & $iOpponents & @CRLF & _ActionString($aActionCount)
		
	;_Log('OK - $iSeat = ' & $iSeat)
	_Log('OK (river) - $sHand = ' & $sHand)
	;_Log('OK - $iBlind = ' & $iBlind)
	;_Log('OK - $iButton = ' & $iButton)
	;_Log('OK - $iPosition = ' & $iPosition)
	;_Log('OK - $iOpponents = ' & $iOpponents)
	_Log('OK (river) - $aActionCount = ' & _ActionString($aActionCount))
	_Log('OK (river) - $iScore = ' & $iScore)
	_Log('OK (river) - Score Adj = ' & $zScore)
	
	If $aActionCount[5] Then
		$zScore = 0
		$iScore = 0
		$gScore = 0
		$iNoGameCount = 100
		Dead_Eye_Fred_NOGAME($iSeat, $sHand)
	EndIf

	For $i = 1 To $sAction[0][0]
		$aTemp = StringSplit($sAction[$i][0], "-", 2)
		$aAction[$i - 1][0] = $aTemp[0]
		$aAction[$i - 1][1] = $aTemp[1]
		$aAction[$i - 1][2] = $sAction[$i][1]
	Next
	For $i = 0 To UBound($aAction) - 1
		If $iScore >= $aAction[$i][0] And $iScore <= $aAction[$i][1] Then
			$gScore = $aAction[$i][2]
		EndIf
	Next
	
	;for tooltip
	If $gScore = "all_in" Then
		_ToolTip($sDebug, 'All In')
	ElseIf $gScore = "raise" And $aActionCount[1] =0 Then
		;_Log('OK - Raise')
		_ToolTip($sDebug, 'Raise')
	ElseIf $gScore = "raise" And $aActionCount[1] >0 Then
		;_Log('OK - Raised - Calling Any')
		_ToolTip($sDebug, 'Raised - Calling Any')
	ElseIf $gScore = "call_upto" Then		
		;_Log('OK - Call_UpTo')
		_ToolTip($sDebug, 'Call_UpTo')
	ElseIf $gScore = "call" Then
		;_Log('OK - Call')
		_ToolTip($sDebug, 'Call')
	Else
		;_Log('OK - Check/Fold')
		_ToolTip($sDebug, 'Check/Fold')
	EndIf
	
	;real thing
	If _MyTurn() And $sStreet == 'RIVER' Then
		$sDebug = 'Hand: ' & $sHand & @CRLF & 'Score Adjustment: ' & $zScore & @CRLF &'Score: ' & $iScore & @CRLF & 'River Call Amt: ' & $camount & @CRLF & 'Called Amt: ' & $famount & @CRLF & 'Banking: ' & $iCashChange & @CRLF & 'Players: ' & $iOpponents & @CRLF & _ActionString($aActionCount)
		If $gScore = "all_in" Then
			_ToolTip($sDebug, 'All In')
			_PlayTurnRaise($iBlind * 1000, 'any')
		ElseIf $gScore = "raise" And $aActionCount[1] =0 Then
			_Log('OK - Raise')
			_ToolTip($sDebug, 'Raise')
			_PlayTurnRaise($iBlind * $rramount, 'any')
		ElseIf $gScore = "raise" And $aActionCount[1] >0 Then
			_Log('OK - Raised - Calling Any')
			_ToolTip($sDebug, 'Raised - Calling Any')
			_PlayTurnCall( 'any')
		ElseIf $gScore = "call_upto" Then	
			_Log('OK - Call_UpTo')
			_ToolTip($sDebug, 'Call_UpTo')
			_PlayFredTurnCall4($camount)
		ElseIf $gScore = "call" Then
			_Log('OK - Call')
			_ToolTip($sDebug, 'Call')
			_PlayTurnCall( 'any')
		Else
			_Log('OK - Check/Fold')
			_ToolTip($sDebug, 'Check/Fold')
			_PlayTurnCheck()
		EndIf
	EndIf
EndFunc  ;==>Dead_Eye_Fred_GAME
