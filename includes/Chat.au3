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
; Chat Functions
;=================================================================
#include-once
#include <file.au3> 
#include "Table.au3"
#include "Debug.au3"
Global $iChatCount=0
Global $bChat = Int(IniRead(@ScriptDir & "\settings.ini","Player","player_chat",1))

Func _Chat($sText='',$bForce=False)
	If $bChat==0 Then
		Return
	EndIf
	If $aTop[0] Then
		If $iChatCount<=0 Or $bForce Then
			$iChatCount = 1000
			If Not $sText Then
				$iLines = _FileCountLines("data\chat.txt")
				$sText = FileReadLine('data\chat.txt',Random(1,$iLines))
			EndIf
			If $sText Then
				MouseClick('left',$aTop[0]+555,$aTop[1]+373,1,10)
				Send($sText)
				Send('{ENTER}')
			EndIf
		Else
			$iChatCount = $iChatCount-1
		EndIf
	EndIf
EndFunc