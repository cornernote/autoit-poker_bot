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
; Table Functions
;=================================================================
#include-once
#Include "Lobby.au3"
#Include "Blind.au3"
#Include "Seat.au3"
#Include "Debug.au3"

Global $iSitStuck = 0
Global $aTop[2]
Global $sTableChecksums = StringSplit(FileRead('..\data\table.txt'),',')
Global $iBlind = 0
Global $xBank = 0
Global $yBank = 0
Global $zBank = 0
Global $tableBuyin=20
Global $bPaused=False


Func _Table($iStart=0)
	Local $aPosition[2]

	Local $aWinPos = WinGetPos($browserTitle)
	If IsArray($aWinPos) And $aWinPos[2] And $aWinPos[0]>0 Then
		If $iStart==0 Then
			$iStart = $iStart+$aWinPos[1]
		EndIf
		$aSearch = PixelSearch($aWinPos[0],$iStart,$aWinPos[2],$aWinPos[3], 0x364C63);
	Else
		$aSearch = PixelSearch(0,$iStart,@DesktopWidth,@DesktopHeight, 0x364C63);
	EndIf

	If @error <> 0 Then
		Return $aPosition
	EndIf
	$iChecksum = PixelChecksum($aSearch[0]-1,$aSearch[1]-1,$aSearch[0],$aSearch[1])
	For $i = 1 to $sTableChecksums[0]
		If $iChecksum==Int($sTableChecksums[$i]) Then
			$aPosition[0] = $aSearch[0]
			$aPosition[1] = $aSearch[1]
		EndIf
	Next
	If Not $aPosition[0] Then
		$aPosition = _Table($aSearch[1]+1)
	EndIf
	Return $aPosition
EndFunc

Func _TableStand()
	MouseClick('left',$aTop[0]+710,$aTop[1]+35,1,0) ;changed from 10 to 0 so he stands instantly
	Sleep(1000)
EndFunc

Func _TableStand2()
	$aResult = _FindBMP("SCREEN",$sDataPath & "\bmp\stand_up.bmp")
	If $aResult[1]==True Then
		_Log('_Stand Up')
		MouseClick('left',$aResult[3],$aResult[4],1,0)
		Sleep(1000)
		Return True
	EndIf
EndFunc

Func _TableStanding()
	Local $iChecksum = PixelChecksum($aTop[0]+710,$aTop[1]+35,$aTop[0]+715,$aTop[1]+40)
	If $iChecksum == 3486926225 Or $iChecksum == 3416933765 Then
		Return True
	EndIf
	Return False
EndFunc

Func _TableBank($iSeat=0,$iBuyin=0)
	If $iBuyin==0 Then $iBuyin = $iBlind * $tableBuyin
	_TableStand()
	_TableSit($iSeat,$iBuyin)
EndFunc

Func _TableSit($iSeat=0,$iBuyin=0)
	While $bPaused
		Sleep(1000)
	Wend
	If $iSitStuck > 5 Then
		$iSitStuck = 0
		_PopupClose()
		Return False
	ElseIf $aTop[0] Then
		If Not $iSeat Then $iSeat = _SeatAvailable()
		If $iSeat Then
			If Not $iBlind Then $iBlind = _Blind()
			If Not $iBuyin Then $iBuyin = $iBlind * $tableBuyin
			If Not $iBuyin Then
				_Log('_TableSit: unknown blinds')
				Return False
			Else
				$aSeat = _SeatPosition($iSeat)
				MouseClick('left',$aTop[0]+$aSeat[0],$aTop[1]+$aSeat[1], 1, 5) ; changed to 5
				Sleep(2000)
				Send($iBuyin)
				Send("{ENTER}")
				MouseMove($aTop[0],$aTop[1],0)
				$iCashChange = False
				$just_banked = _totalchips()
				$iSitStuck = $iSitStuck+1
				Return True
			EndIf
		EndIf
	EndIf
EndFunc

Func _TableBuyin($iBuyin=0)
	$aResult = _FindBMP("SCREEN",$sDataPath & "\bmp\table_buyin.bmp")
	;$xBank = 0 ; sets forcebank to false
	;$yBank = 0 ; sets forcebank to false
	;$zBank = 0 ; sets forcebank to false
	;$cWon = False ; we lost 
	$just_banked = _totalchips()
	If $aResult[1]==True Then
		_Log('_TableBuyin')
		If Not $iBuyin Then $iBuyin = $iBlind * $tableBuyin
		If Not $iBuyin Then
			MouseClick('left',$aResult[3],$aResult[4],1,10)
			MouseMove($aTop[0],$aTop[1],0)
			Return True
		Else
			$iCashChange = False
			Send($iBuyin)
			Send("{ENTER}")
			MouseMove($aTop[0],$aTop[1],0)
			Return True
		EndIf
	EndIf
EndFunc
