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
; Version Checking Functions
;=================================================================
#include-once
#include "Debug.au3"

Func _Version()
	Dim $hUpdateUrl = InetGet("http://botage.com/?action=version", "data/version_latest.txt", 1, 0)
	If $hUpdateUrl == 0 Then
		MsgBox(0, "Update Error", "Unable to check for updates. Please check your internet connection.")
		Return
	EndIf
	$v = FileRead("data/version.txt")
	$av = StringSplit($v,'.')
	$l = FileRead("data/version_latest.txt")
	$al = StringSplit($l,'.')
	If Int($av[1]) < Int($al[1]) Or (Int($av[1]) == Int($al[1]) And Int($av[2]) < Int($al[2])) Then
		MsgBox(0, "Poker Bot Update", "A new version is available.")
	EndIf
EndFunc