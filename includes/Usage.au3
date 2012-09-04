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
; Usage Logging Functions
;=================================================================
#include-once
#include "Debug.au3"
#include "vendor/HardwareHash/HHash.au3"
Global $sHardwareHash=0
Global $iUsageCount=0
Global $bUsageSend = Int(IniRead(@ScriptDir & "\settings.ini","Usage","usage_send", 1))

Func _Usage()
	If $bUsageSend Then
		If $sHardwareHash==0 Then
			$sHardwareHash = _GenHHash()
		EndIf
		If $iUsageCount<=0 Then
			InetGet('http://botage.com/?action=ping&hardware='&$sHardwareHash, 'data/tmp', 1, 1)
			$iUsageCount = 250
		Else
			$iUsageCount = $iUsageCount-1
		EndIf
	EndIf
EndFunc