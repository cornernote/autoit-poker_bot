#include-once

Func CheckBot()
   Local $cards = _Cards()
   Local $cardsString = _CardsString($cards)
   Local $hand = _Hand($cards)
   Local $street = _Street($hand)
   Local $opponents = _Opponents()
   Local $opponentsCount = _OpponentsCount($opponents)
   Local $opponentsString = _OpponentsString($opponents)
   Local $rank = _HandEval($hand, $opponentsCount)
   Local $log = "CheckBot[" & StringLeft($street,1) & "][" & $cardsString & "] vs" & $opponentsCount & " [" & $opponentsString & "] rank=" & $rank
   _Log($log)
   If $street<>'N' Then
	  CheckBot_Play($log)
   EndIf
EndFunc

Func CheckBot_Play($log)
   _PlayCheck($log)
EndFunc
