;=================================================================
; Read the Blind Amount
;=================================================================
#include-once

#include <Array.au3>

; stores the read blind
Global $blind

; used to get checksum if the match fails
Global $blindFailChecksum

; reset cards array
Func _BlindReset()
   $blind = False
   $blindFailChecksum = False
EndFunc

; read action buttons
Func _BlindRead()
   _BlindReset()
   ; TODO
   $blind = "400"
EndFunc
