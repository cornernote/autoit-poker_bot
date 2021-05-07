#include-once
#include <Array.au3>

Func _Street()
   Local $hand = _Hand()
   If StringInStr($hand,'-') Then Return 'WAITING'
   Local $cards = StringSplit($hand, ' ')
   Local $cardCount = Ubound($cards) - 1
   If $cardCount < 2 Then
	  Return 'WAITING'
   EndIf
   If $cardCount == 2 Then
	  Return 'PREFLOP'
   EndIf
   If $cardCount == 5 Then
	  Return 'FLOP'
   EndIf
   If $cardCount == 6 Then
	  Return 'TURN'
   EndIf
   If $cardCount == 7 Then
	  Return 'RIVER'
   EndIf
EndFunc
