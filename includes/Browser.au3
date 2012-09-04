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
; Browser Functions
;=================================================================
#include-once
Global $browserFile = IniRead(@ScriptDir & "\settings.ini","Browser","browser_file","C:\Program Files\Mozilla Firefox\firefox.exe")
Global $browserTitle = IniRead(@ScriptDir & "\settings.ini","Browser","browser_title","Mozilla Firefox")
Global $sPokerLink = 'http://apps.facebook.com/texas_holdem'

Func _BrowserStart()
	_Log('_BrowserStart')
	If WinExists($browserTitle)==0 Then
		ShellExecute($browserFile, $sPokerLink)
	EndIf
	WinActivate($browserTitle)
	WinWaitActive($browserTitle)
	Send('^0')
	WinMove($browserTitle,'',0,0,@DesktopWidth,@DesktopHeight)
EndFunc

Func _BrowserStop()
	_Log('_BrowserStop')
	If WinExists($browserTitle) Then
		WinClose($browserTitle)
	EndIf
EndFunc

Func _BrowserRefresh()
	_Log('_BrowserRefresh')
	If Not WinExists($browserTitle) Then
		_BrowserStart()
	Else
		MouseClick('left',5,300)
		Send('{F5}')
	EndIf
EndFunc

Func _BrowserCloseTab()
	;If $browserFile<>'iexplore.exe' And $browserFile<>'chrome.exe' Then
	;	_Log('_BrowserCloseTab')
	;	Send('^{F4}')
	;EndIf
EndFunc

;=================================================================
; Bot Console
;=================================================================

Func _BrowserWindowLink()
	_Log('_BrowserWindowLink')
	TrayTip('POKER BOT LOADING', 'Init...', 1000)
	Local $sPlayerPokerLink
	If FileExists($sDataPath&'/url.txt') Then
		TrayTip('POKER BOT LOADING', 'Loading table.', 1000)
		$sPlayerPokerLink = FileRead($sDataPath&'/url.txt')
		_BrowserWindow($sPlayerPokerLink)
	Else
		TrayTip('POKER BOT LOADING', 'Downloading poker page.', 1000)
		If InetGet($sPokerLink, $sDataPath&"/tmp", 1, 0) == 0 Then
			MsgBox(0, "Download Error", "Cannot download the poker page.")
			MsgBox(0, "Download Error", "Please login to " & $sPokerLink & " using Internet Explorer and tick the 'Remember Me' checkbox.")
			Run('iexplore '&$sPokerLink)
			Exit
		Else
			TrayTip('POKER BOT LOADING', 'Finding poker link.', 1000)
			$array = StringRegExp(FileRead($sDataPath&"/tmp"), '"(http://facebook\.poker\.somepokergame\.com/poker/launch\.php.+?)"', 2)
			FileDelete($sDataPath&"/tmp")
			If IsArray($array) And $array[1] Then
				TrayTip('POKER BOT LOADING', 'Loading table.', 1000)
				$sPlayerPokerLink = StringReplace($array[1],'&amp;','&')
				FileWrite($sDataPath&'/url.txt',$sPlayerPokerLink)
				_BrowserWindow($sPlayerPokerLink)
			Else
				MsgBox(0, "Download Error", "Cannot find the poker link.")
				MsgBox(0, "Download Error", "Please login to " & $sPokerLink & " using Internet Explorer and tick the 'Remember Me' checkbox.")
				Run('iexplore '&$sPokerLink)
				Exit
			EndIf
		EndIf
	EndIf
EndFunc

Func _BrowserWindow($sPlayerPokerLink)
	_Log('_BrowserWindow')
	Local $oIE, $GUIActiveX, $msg

    $oIE = ObjCreate("Shell.Explorer.2")
    GUICreate($browserTitle, 781, 625, 0, 0, BitOR($WS_OVERLAPPEDWINDOW, $WS_CLIPSIBLINGS, $WS_CLIPCHILDREN))
    $GUIActiveX = GUICtrlCreateObj ($oIE, 0, 0, 781, 575)
    GUISetState() ;Show GUI
    $guiStatus = GUICtrlCreateLabel("Pokerbot Status: Auto Play", 16, 575, 500, 30)
    GUICtrlSetFont(-1, 14, 800, 0, "MS Sans Serif")
    GUICtrlCreateLabel("press [CTRL+ALT+P] to toggle pause and [CTRL+ALT+X] to exit", 16, 605, 500, 15)
    $oIE.navigate($sPlayerPokerLink)

    While 1
        $msg = GUIGetMsg()
		MainLoop()

        Select
            Case $msg = $GUI_EVENT_CLOSE
                ExitLoop
        EndSelect
    WEnd

    GUIDelete()
EndFunc
