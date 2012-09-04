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
; Lobby Functions
;=================================================================
#include-once
#include "Table.au3"
#include "vendor/FindBMP/FindBMP.au3"

Global $iBlind = 0
Global $aTop[2]
Global $browserTitle = 'none'
Global $sDataPath = '../data'

Func _Lobby()
	$iBlind = 0
	MouseClick('left',$aTop[0]+710,$aTop[1]+15,10)
EndFunc

Func _LobbyJoin()
	$aResult = _FindBMP("SCREEN",$sDataPath & "\bmp\lobby_playnow.bmp")
	$GetRoomChips = True
	If $aResult[1]==True Then
		_Log('_LobbyJoin')
		MouseClick('left',$aResult[3],$aResult[4],1,10)
		Sleep(1000)
		Return True
	EndIf
EndFunc