#include-once

Func PlayerInit()
   Local $filename = @ScriptDir & "\player.ini"
   Local $sectionNames = IniReadSectionNames($filename)
   For $i=1 To $sectionNames[0]
	  Local $sectionVars = IniReadSection($filename, $sectionNames[$i])
	  For $j=1 To $sectionVars[0][0]
		 Assign('player_'&$sectionNames[$i]&'_'&$sectionVars[$j][0], $sectionVars[$j][1], $ASSIGN_FORCEGLOBAL)
	  Next
   Next
EndFunc



Func Player()
   $profilePlayAction = 'call'
   $profilePlayRaiseAmount = 0
   $profilePlayMaximumCallAmount = $blind/2
   Local $street = _Street()
   If $street=="WAITING" Then
	  ; do nothing
   ElseIf $street=="PREFLOP" Then
	  Player_PREFLOP()
   Else
	  Player_POSTFLOP(StringLower($street))
   EndIf
EndFunc


Func Player_PREFLOP()
   If Player_isHandInList($player_preflop_action_all_in) Then
	  $profilePlayAction = 'all_in'
   ElseIf Player_isHandInList($player_preflop_action_raise) Then
	  $profilePlayAction = 'raise'
	  $profilePlayRaiseAmount = Number($player_preflop_factor_raise) * $blind
   ElseIf Player_isHandInList($player_preflop_action_call) Then
	  $profilePlayAction = 'call'
	  $profilePlayMaximumCallAmount = 'any'
   ElseIf Player_isHandInList($player_preflop_action_call_upto) Then
	  $profilePlayAction = 'call'
	  $profilePlayMaximumCallAmount = Number($player_preflop_factor_call_upto) * $blind
   EndIf
EndFunc


Func Player_POSTFLOP($street)
   Local $eval = Number(_HandEval(_Hand(), _OpponentsCount()))
   If $eval >= Number(Eval("player_"&$street&"_action_all_in")) Then
	  $profilePlayAction = 'all_in'
   ElseIf $eval >= Number(Eval("player_"&$street&"_action_raise")) Then
	  $profilePlayAction = 'raise'
	  $profilePlayRaiseAmount = Number(Eval("player_"&$street&"_factor_raise")) * $blind
   ElseIf $eval >= Number(Eval("player_"&$street&"_action_call")) Then
	  $profilePlayAction = 'call'
	  $profilePlayMaximumCallAmount = 'any'
   ElseIf $eval >= Number(Eval("player_"&$street&"_action_call_upto")) Then
	  $profilePlayAction = 'call'
	  $profilePlayMaximumCallAmount = Number(Eval("player_"&$street&"_factor_call_upto")) * $blind
   EndIf
EndFunc


Func Player_isHandInList($checkCardsString)
   Local $checkCards = StringSplit($checkCardsString, " ")
   For $i=1 To $checkCards[0]
	  If (Player_isHand($checkCards[$i])) Then
		 Return True
	  EndIf
   Next
   Return False
EndFunc

Func Player_isHand($checkCardString)
   Local $checkCard = StringSplit($checkCardString, "")
   ; check if numbers match
   If ($cards[0][0]==$checkCard[1] And $cards[1][0]==$checkCard[2]) Or ($cards[0][0]==$checkCard[2] And $cards[1][0]==$checkCard[1]) Then
	  ; check if suit is required
	  If $checkCard[0]==3 And StringLower($checkCard[3])=='s' Then
		 ; check if suit matches
		 If $cards[0][1]==$cards[1][1] Then
			Return True
		 EndIf
	  Else
		 ; no suit check required
		 Return True
	  EndIf
   EndIf
   Return False
EndFunc

