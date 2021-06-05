#include-once

Func BingoBotInit()
EndFunc

Func BingoBot()
   $profilePlayAction = 'call'
   $profilePlayRaiseAmount = 0
   $profilePlayMaximumCallAmount = $blind/2
   Local $street = _Street()
   If $street=="WAITING" Then
	  ; do nothing
   ElseIf $street=="PREFLOP" Then
	  ; AA, KK
	  If $cards[0][0] == $cards[1][0] And ($cards[0][0] == 'A' Or $cards[0][0] == 'K') Then
		 $profilePlayAction = 'all_in'
	  EndIf
	  ; AK
	  If ($cards[0][0] == 'A' And $cards[1][0] == 'K') Or ($cards[0][0] == 'K' And $cards[1][0] == 'A') Then
		 $profilePlayAction = 'all_in'
	  EndIf
	  ; QQ, JJ, TT
	  If $cards[0][0] == $cards[1][0] And ($cards[0][0] == 'Q' Or $cards[0][0] == 'J' Or $cards[0][0] == 'T') Then
		 $profilePlayAction = 'all_in'
	  EndIf
	  If $cards[0][1] == $cards[1][1] Then
		 ; AQs
		 If ($cards[0][0] == 'A' And $cards[1][0] == 'Q') Or ($cards[0][0] == 'Q' And $cards[1][0] == 'A') Then
			$profilePlayAction = 'all_in'
		 EndIf
		 ; AJs
		 If ($cards[0][0] == 'A' And $cards[1][0] == 'J') Or ($cards[0][0] == 'J' And $cards[1][0] == 'A') Then
			$profilePlayAction = 'all_in'
		 EndIf
		 ; ATs
		 If ($cards[0][0] == 'A' And $cards[1][0] == 'T') Or ($cards[0][0] == 'T' And $cards[1][0] == 'A') Then
			$profilePlayAction = 'all_in'
		 EndIf
	  EndIf
   ElseIf _HandEval(_Hand(), _OpponentsCount()) >= 0.7 Then
	  $profilePlayAction = 'all_in'
   EndIf
EndFunc
