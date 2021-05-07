#include-once

Func BingoBot()
   _Cards()
   _Opponents()

   Local $cardsString = _CardsString($cards)
   Local $hand = _Hand($cards)
   Local $street = _Street($hand)
   Local $opponentsCount = _OpponentsCount($opponents)
   Local $opponentsString = _OpponentsString($opponents)
   Local $eval = _HandEval($hand, $opponentsCount)

   ; TODO - move this
   ; update gui
   If _PlayCanPlay() Then
	  _PlayCanAllIn()
	  _PlayCanRaise()
	  _PlayCanCall()
	  _PlayCanCheck()
	  _PlayCanFold()
   EndIf
   _GuiUpdate($cards)

   Local $log = "BingoBot[" & StringLeft($street,1) & "][" & $cardsString & "] vs" & $opponentsCount & " [" & $opponentsString & "] eval=" & $eval

   _Log($log)
   GUICtrlSetData($guiCardLabel, $log)
   ;_GuiUpdateButton('?', $guiAction)

   If $street=='NOGAME' Then
	  GUICtrlSetData($guiAction, 'waiting')
   ElseIf $street=="PREFLOP" Then
	  BingoBot_Preflop($log, $cards, $street)
   Else
	  BingoBot_Play($log, $eval)
   EndIf
EndFunc

Func BingoBot_Preflop($log, $cards, $street)
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
	  _PlayAllIn($log)
   Else
	  _PlayCheck($log)
   EndIf
EndFunc

Func BingoBot_Play($log, $eval)
   If $eval >= 0.80 Then
	  _PlayAllIn($log)
   Else
	  _PlayCheck($log)
   EndIf
EndFunc
