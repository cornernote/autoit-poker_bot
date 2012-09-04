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
; Popup Functions
;=================================================================
#include-once
#include "Lobby.au3"
#include "Debug.au3"
#include "vendor/FindBMP/FindBMP.au3"
#include "vendor/FileListToArray/FileListToArray.au3"

Global $sDataPath = '../data'

Func _PopupClose()
	Local $aFiles = _FileListToArrayEx($sDataPath & "\bmp\", "popup_*.bmp")
	For $i = 1 To $aFiles[0]
		$aResult = _FindBMP("SCREEN",$aFiles[$i])
		If $aResult[1]==True Then
			_Log('_PopupClose: '& $aFiles[0])
			MouseClick('left',$aResult[3],$aResult[4],1,10)
			Return True
		EndIf
	Next
EndFunc