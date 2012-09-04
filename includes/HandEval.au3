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
; Hand Evaluation Functions
;=================================================================
#include-once

Global $sDataPath = '../data'

Func _SimHandMulti($hand, $nopponents)
	If $hand==False Then Return False
	If $hand=='' Then Return False
	If StringLeft($hand,2)=='--' Then Return False
	
	$sFilename = $sDataPath&'\hand\'&StringReplace($hand,' ','-')&'_'&$nopponents&'.txt'
	If FileExists($sFilename) Then
		Return FileRead($sFilename)
	EndIf
	
	$dll = DllOpen ("includes/vendor/PSIM/psim.dll")
	If $dll = -1 Then Return False
	$simResultsStruct = "float win; float tie; float lose; float winSd; float tieSd; float loseSd; float d94; float d90; int evaluations"
	$simResults = DllStructCreate($simResultsStruct)
	$result = DllCall($dll, "none", "SimulateHandMulti", "str", $hand, "ptr", DllStructGetPtr($simResults), "uint", 600, "uint", 400, "uint", $nopponents)
	DllClose($dll)
	If @error <> 0 then
		FileWrite($sFilename,0)
		Return False
	Else
		$score = Round(DllStructGetData($simResults, "winSd") + DllStructGetData($simResults, "tieSd"),2)
		FileWrite($sFilename,$score)
		Return $score
	Endif
EndFunc