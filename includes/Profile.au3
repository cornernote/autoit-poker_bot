#include-once
#include "profiles/CheckBot.au3"
#include "profiles/BingoBot.au3"
#include "profiles/Player.au3"

; specifies which action the bot will take
Global $profilePlayAction = 'check'

; specifies the amount the bot will raise
Global $profilePlayRaiseAmount = 0

; specifies the maximum amount the bot will call
Global $profilePlayMaximumCallAmount = 0 ; int|'any'

Func _ProfileInit()
   CheckBotInit()
   BingoBotInit()
   PlayerInit()
EndFunc
