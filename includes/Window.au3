#include-once
#include <Array.au3>

Global $windowPos[4]


Func _Window()
   _WindowPos()
   _WindowCloseImBack()
   _WindowCloseInvite()
EndFunc   ;==>_Window


Func _WindowPos()
   Local $gameTitle = IniRead(@ScriptDir & "\settings.ini","game","title", 0)
   Opt("WinTitleMatchMode", -2)
   Local $winPos = WinGetPos($gameTitle)
   If @error Then
	  ;_Log("window with name '" & $gameTitle & "' not found...")
	  Return
   EndIf
   If $winPos[2] <> 1920 Or $winPos[3] <> 1080 Then
	  ;_Log("window must be 1920x1080 (currently " & $winPos[2] & "x" & $winPos[3] & ")")
	  Return
   EndIf
   WinMove ($gui, "", $winPos[0], $winPos[1]+50)
   $windowPos = $winPos
EndFunc   ;==>_WindowPos


Func _WindowCloseImBack()
   ;_Log('_WindowCloseImBack')
   Local $x = $windowPos[0]+Int(IniRead(@ScriptDir & "\settings.ini","window","im_back_x", 0)) ; x pos
   Local $y = $windowPos[1]+Int(IniRead(@ScriptDir & "\settings.ini","window","im_back_y", 0)) ; y pos
   Local $checksums = StringSplit(IniRead(@ScriptDir & "\settings.ini","window","im_back_checksums", ""), ",") ; pixel checksums
   Local $size = 2
   Local $currentChecksum = PixelChecksum($x-$size, $y-$size, $x+$size, $y+$size)
   For $i = 1 To $checksums[0]
	  Local $checksum = $checksums[$i]
	  If $currentChecksum = $checksum Then
		 _Log('_WindowCloseImBack = yes: ' & $currentChecksum)
		 MouseClick($MOUSE_CLICK_LEFT, $x, $y, 1)
		 Sleep(500)
		 MouseMove($windowPos[0], $windowPos[1], 1)
		 Return True
	  EndIf
   Next
   ;_Log('_WindowCloseImBack = no: ' & $currentChecksum)
   Return False
EndFunc   ;==>_WindowCloseImBack


Func _WindowCloseInvite()
   ;_Log('_WindowCloseInvite')
   Local $x = $windowPos[0]+Int(IniRead(@ScriptDir & "\settings.ini","window","close_invite_x", 0)) ; x pos
   Local $y = $windowPos[1]+Int(IniRead(@ScriptDir & "\settings.ini","window","close_invite_y", 0)) ; y pos
   Local $checksums = StringSplit(IniRead(@ScriptDir & "\settings.ini","window","close_invite_checksums", ""), ",") ; pixel checksums
   Local $size = 2
   Local $currentChecksum = PixelChecksum($x-$size, $y-$size, $x+$size, $y+$size)
   For $i = 1 To $checksums[0]
	  Local $checksum = $checksums[$i]
	  If $currentChecksum = $checksum Then
		 _Log('_WindowCloseInvite = yes: ' & $currentChecksum)
		 MouseClick($MOUSE_CLICK_LEFT, $x, $y, 1)
		 Sleep(500)
		 MouseMove($windowPos[0], $windowPos[1], 1)
		 Return True
	  EndIf
   Next
   ;_Log('_WindowCloseInvite = no: ' & $currentChecksum)
   Return False
EndFunc   ;==>_WindowCloseInvite



Func _WindowNextGame()
   ;_Log('_WindowNextGame')
   Local $x = $windowPos[0]+Int(IniRead(@ScriptDir & "\settings.ini","window","next_game_x", 0)) ; x pos
   Local $y = $windowPos[1]+Int(IniRead(@ScriptDir & "\settings.ini","window","next_game_y", 0)) ; y pos
   Local $checksums = StringSplit(IniRead(@ScriptDir & "\settings.ini","window","next_game_checksums", ""), ",") ; pixel checksums
   Local $size = 2
   Local $currentChecksum = PixelChecksum($x-$size, $y-$size, $x+$size, $y+$size)
   For $i = 0 To UBound($checksums) - 1
	  Local $checksum = $checksums[$i]
	  If $currentChecksum = $checksum Then
		 _Log('_WindowNextGame = yes: ' & $currentChecksum)
		 If $paused Then Return True

		 Local $date = (@YEAR & "-" & @MON & "-" & @MDAY & "-" & @HOUR & "-" & @MIN & "-" & @SEC & "-" & @MSEC)
		 Local $path = @ScriptDir & "\data\next"
		 DirCreate($path)
		 _ScreenCapture_Capture($path & "\" & $date & ".png", $windowPos[0], $windowPos[1], $windowPos[0]+$windowPos[2]-1, $windowPos[1]+$windowPos[3]-1, False)

		 MouseClick($MOUSE_CLICK_LEFT, $x, $y, 1)
		 Sleep(1500)
		 MouseMove($windowPos[0], $windowPos[1], 1)
		 Return True
	  EndIf
   Next
   ;_Log('_WindowNextGame = no: ' & $currentChecksum)
   Return False
EndFunc   ;==>_WindowNextGame
