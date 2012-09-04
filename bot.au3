#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Icon=bot.ico
#AutoIt3Wrapper_Compression=4
#AutoIt3Wrapper_Run_Tidy=y
#AutoIt3Wrapper_Run_Obfuscator=y
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
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
; AutoIT Settings
;=================================================================
AutoItSetOption("WinTitleMatchMode", 2)

;=================================================================
; Includes
;=================================================================
#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>
#include "includes/Usage.au3"
#include "includes/HandHistory.au3"
#include "includes/HandEval.au3"
#include "includes/Debug.au3"
#include "includes/Action.au3"
#include "includes/Browser.au3"
#include "includes/Blind.au3"
#include "includes/Button.au3"
#include "includes/Cards.au3"
#include "includes/Lobby.au3"
#include "includes/Opponent.au3"
#include "includes/PlayTurn.au3"
#include "includes/Popup.au3"
#include "includes/Seat.au3"
#include "includes/Street.au3"
#include "includes/Table.au3"
#include "includes/Version.au3"
#include "includes/Chat.au3"
#include "includes/players/Players.au3"
#include "includes/Readchips.au3"
#include "includes/ReadRaise.au3"

#include "includes/gui_startup.au3"

;=================================================================
; Globals
;=================================================================
Global $iCashChange = False
Global $bForceBank = False
Global $iNoGameCount = 0
Global $iNoGameReason = ''
Global $iStuck = 0
Global $iButton = 0
Global $bRaised = False
Global $aTop[2]
Global $bPaused = False
Global $guiStatus

Global $sPlayer = IniRead(@ScriptDir & "\settings.ini", "Player", "player_file", "Dead_Eye_Fred")
Global $iPause = Int(IniRead(@ScriptDir & "\settings.ini", "Poker", "loop_pause", 200))
Global $sPokerLink = IniRead(@ScriptDir & "\settings.ini", "Poker", "poker_link", 'http://apps.facebook.com/texas_holdem')
Global $sDataPath = IniRead(@ScriptDir & "\settings.ini", "Log", "data_path", @ScriptDir & '\data')
Global $sLogPath = IniRead(@ScriptDir & "\settings.ini", "Log", "log_path", @ScriptDir & '\log')
Global $bLogText = Int(IniRead(@ScriptDir & "\settings.ini", "Log", "log_text", 0))
Global $bLogHand = Int(IniRead(@ScriptDir & "\settings.ini", "Log", "log_hand", 10))
Global $logScreenCapture = Int(IniRead(@ScriptDir & "\settings.ini", "Log", "log_screen_capture", 0))
Global $tableBuyin = Int(IniRead(@ScriptDir & "\settings.ini", "Table", "table_buyin", 10))
Global $sTableChecksums = StringSplit(FileRead(@ScriptDir & '\data\table.txt'), ',')
Global $browserFile = IniRead(@ScriptDir & "\settings.ini", "Browser", "browser_file", "console")
Global $browserTitle = IniRead(@ScriptDir & "\settings.ini", "Browser", "browser_title", "Poker Bot Console")

;=================================================================
; Kill Switch
;=================================================================
HotKeySet("^!x", "Terminate")
Func Terminate()
	Exit
EndFunc   ;==>Terminate

;=================================================================
; Pause Switch
;=================================================================
HotKeySet("^!p", "TogglePokerbot")
Func TogglePokerbot()
	If $bPaused == False Then
		$bPaused = True
	Else
		$bPaused = False
	EndIf
	Select
		Case $bPaused = True
			GUICtrlSetData($guiStatus, "Pokerbot Status: Paused")
		Case $bPaused = False
			GUICtrlSetData($guiStatus, "Pokerbot Status: Auto Play")
	EndSelect
EndFunc   ;==>TogglePokerbot

;=================================================================
; Error Handler
;=================================================================
$oMyError = ObjEvent("AutoIt.Error", "MyErrFunc")
Func MyErrFunc()
	SetError(1) ; to check for after this function returns
EndFunc   ;==>MyErrFunc

;=================================================================
; Check Version
;=================================================================
;_Version()

;=================================================================
; Bot Console
;=================================================================
_frmStart()
_ToolTip(' ' & @CRLF & ' Fixed the calling staying over to the next turn. '& @CRLF &'  ', 'Z-Bot Alpha 7.7 (Kozkon)')
If $browserFile == 'console' Then
	_BrowserWindowLink()
Else
	While 1
		MainLoop()
	WEnd
EndIf

;=================================================================
; Main Loop to decide which driver to load
;=================================================================

Func MainLoop()
	If Not $bPaused Then
		If FileRead($sDataPath & '/seat/done.txt') Then
			DriveBot()
		Else
			DriveSeat()
		EndIf
	EndIf
EndFunc   ;==>MainLoop

;=================================================================
; Main Driver
;=================================================================

Func DriveBot()
	_Log('START - BOT LOOP')
	$aTop = _Table()
	_ScreenCapture()
	If $aTop[0] Then
		Call($sPlayer)
		_Log('OK - table found')
		If Not _TableStanding() Then
			_Log('OK - sitting')
			If _Seat() Then
				_Log('OK - seat found')
				Call($sPlayer)
			Else
				_TableBuyin()
				_Log('WARNING - player seat not found')
				_ToolTip('No player seat found.', 'Warning')
				_TableSit()
				;_PopupClose()
			EndIf
		ElseIf Not _TableSit() Then
			_Log('WARNING - player can not sit at table')
			_ToolTip('No empty seat found.', 'Warning')
			_Lobby()
		EndIf
	Else
		_Log('WARNING - table not found')
		If _LobbyJoin() Then
			_Log('OK - joined table')
			$iNoGameCount = 0
			$iCashChange = True
			$bForceBank = True
			For $i = 0 To 5
				If _Seat() Then ExitLoop
				Sleep(100)
			Next
			_Log('WARNING - joined table but cannot find seat')
		Else
			_Log('WARNING - could not join table')
			If $browserFile <> 'console' Then
				_BrowserStart()
				_BrowserCloseTab()
			EndIf
			_TableBuyin()
			;_PopupClose()
			$iStuck = $iStuck + 1
		EndIf
	EndIf

	If $iStuck > 600 Then
		$iStuck = 0
		_Log('WARNING - restarting browser')
		If $browserFile <> 'console' Then
			_BrowserRefresh()
		EndIf
	EndIf

	;	_Usage()
	Sleep($iPause)
EndFunc   ;==>DriveBot

;=================================================================
; Seat Driver
;=================================================================

Func DriveSeat()
	GUICtrlSetData($guiStatus, "Pokerbot Status: Seat Recording")
	Local $aSeats[9]
	$logScreenBlind = 1

	$aTop = _Table()
	If $aTop[0] Then

		$iBlind = _Blind()

		_ToolTip('Recording seats.', 'RECORDING')
		_TableStand()

		Sleep(2000)
		_ScreenCapture()

		_ToolTip('Opponents are being recorded.', 'RECORDING')
		_OpponentCardSave()

		For $i = 1 To 9
			_ToolTip('Sit seat ' & $i & ' is being recorded.', 'RECORDING')
			_SeatChecksumSave($i, 'sit')
		Next

		_TableSit(1)
		Sleep(2000)
		_ScreenCapture()

		_ToolTip('Player seat 1 is being recorded.', 'RECORDING')
		_SeatChecksumSave(1, 'player')
		For $i = 2 To 9
			_ToolTip('Empty seat ' & $i & ' is being recorded.', 'RECORDING')
			_SeatChecksumSave($i, 'empty')
		Next
		_TableStand()
		Sleep(1000)

		_TableSit(2)
		Sleep(2000)
		_ScreenCapture()
		_ToolTip('Player seat 2 is being recorded.', 'RECORDING')
		_SeatChecksumSave(2, 'player')
		_ToolTip('Empty seat 1 is being recorded.', 'RECORDING')
		_SeatChecksumSave(1, 'empty')

		For $i = 3 To 9
			If $i > 9 Then
				$i = $i - 9
			EndIf
			_TableBank($i)
			Sleep(2000)
			_ScreenCapture()
			If Not $aSeats[$i - 1] Then
				_ToolTip('Player seat ' & $i & ' is being recorded.', 'RECORDING')
				_SeatChecksumSave($i, 'player')
				Sleep(500)
				If _Seat() Then
					$aSeats[$i - 1] = $i
				EndIf
			EndIf
		Next

		_TableStand()
		_ToolTip('Your seats have been recorded.', 'DONE')
		FileWrite($sDataPath & '/seat/done.txt', 'done')
		GUICtrlSetData($guiStatus, "Pokerbot Status: Auto Play")
		$logScreenBlind = Int(IniRead(@ScriptDir & "\settings.ini", "Log", "log_screen_blind", 0))
		Sleep(3000)
		_Lobby()
		Return
	Else
		If $browserFile <> 'console' Then
			_BrowserStart()
			_BrowserCloseTab()
		EndIf
		_ToolTip('Please join an empty 9 seat table.', 'TABLE NOT FOUND')
	EndIf
	Sleep(1000)
EndFunc   ;==>DriveSeat