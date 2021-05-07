#include-once

Func BingoBot()
   Local $street = _Street()
   If $street=='WAITING' Then
	  GUICtrlSetData($guiPlay, ' ')
   ElseIf $street=="PREFLOP" Then
	  BingoBot_Preflop()
   Else
	  BingoBot_Play()
   EndIf
EndFunc

Func BingoBot_Preflop()
   $allIn = False;
   ; AA, KK
   If $cards[0][0] == $cards[1][0] And ($cards[0][0] == 'A' Or $cards[0][0] == 'K') Then
	  $allIn = True
   EndIf
   ; AK
   If ($cards[0][0] == 'A' And $cards[1][0] == 'K') Or ($cards[0][0] == 'K' And $cards[1][0] == 'A') Then
	  $allIn = True
   EndIf
   ; QQ, JJ, TT
   If $cards[0][0] == $cards[1][0] And ($cards[0][0] == 'Q' Or $cards[0][0] == 'J' Or $cards[0][0] == 'T') Then
	  $allIn = True
   EndIf
   If $cards[0][1] == $cards[1][1] Then
	  ; AQs
	  If ($cards[0][0] == 'A' And $cards[1][0] == 'Q') Or ($cards[0][0] == 'Q' And $cards[1][0] == 'A') Then
		 $allIn = True
	  EndIf
	  ; AJs
	  If ($cards[0][0] == 'A' And $cards[1][0] == 'J') Or ($cards[0][0] == 'J' And $cards[1][0] == 'A') Then
		 $allIn = True
	  EndIf
	  ; ATs
	  If ($cards[0][0] == 'A' And $cards[1][0] == 'T') Or ($cards[0][0] == 'T' And $cards[1][0] == 'A') Then
		 $allIn = True
	  EndIf
   EndIf
   ; lets do it !
   If $allIn Then
	  _PlayAllIn()
   Else
	  _PlayCheck()
   EndIf
EndFunc

Func BingoBot_Play()
   If _HandEval(_Hand(), _OpponentsCount()) >= 0.80 Then
	  _PlayAllIn()
   Else
	  _PlayCheck()
   EndIf
EndFunc
