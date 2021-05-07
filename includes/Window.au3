#include-once
#include <Array.au3>

Global $window[4]


Func _WindowRead()
   _WindowReset()
   Opt("WinTitleMatchMode", -2)
   Local $winPos = WinGetPos($ini_game_title)
   If @error Then
	  _Log("window with name '" & $ini_game_title & "' not found...")
	  Return
   EndIf
   If $winPos[2] <> 1920 Or $winPos[3] <> 1080 Then
	  _Log("window must be 1920x1080 (currently " & $winPos[2] & "x" & $winPos[3] & ")")
	  Return
   EndIf
   $window = $winPos
EndFunc

Func _WindowReset()
   Local $_window[UBound($window)]
   $window = $_window
EndFunc

Func _WindowClosePopups()
   _WindowCloseImBack()
   _WindowCloseInvite()
EndFunc

Func _WindowCloseImBack()
   ;_Log('_WindowCloseImBack')
   Local $x = $window[0]+$ini_window_im_back_x
   Local $y = $window[1]+$ini_window_im_back_y
   Local $checksums = StringSplit($ini_window_im_back_checksums, ",")
   Local $size = 2
   Local $currentChecksum = PixelChecksum($x-$size, $y-$size, $x+$size, $y+$size)
   For $i = 1 To $checksums[0]
	  Local $checksum = $checksums[$i]
	  If $currentChecksum = $checksum Then
		 _Log('_WindowCloseImBack = yes: ' & $currentChecksum)
		 If $paused Then Return True
		 MouseClick($MOUSE_CLICK_LEFT, $x, $y, 1)
		 Sleep(500)
		 MouseMove($window[0], $window[1], 1)
		 Return True
	  EndIf
   Next
   ;_Log('_WindowCloseImBack = no: ' & $currentChecksum)
   Return False
EndFunc   ;==>_WindowCloseImBack


Func _WindowCloseInvite()
   ;_Log('_WindowCloseInvite')
   Local $x = $window[0]+$ini_window_close_invite_x
   Local $y = $window[1]+$ini_window_close_invite_y
   Local $checksums = StringSplit($ini_window_close_invite_checksums, ",")
   Local $size = 2
   Local $currentChecksum = PixelChecksum($x-$size, $y-$size, $x+$size, $y+$size)
   For $i = 1 To $checksums[0]
	  Local $checksum = $checksums[$i]
	  If $currentChecksum = $checksum Then
		 _Log('_WindowCloseInvite = yes: ' & $currentChecksum)
		 If $paused Then Return True
		 MouseClick($MOUSE_CLICK_LEFT, $x, $y, 1)
		 Sleep(500)
		 MouseMove($window[0], $window[1], 1)
		 Return True
	  EndIf
   Next
   ;_Log('_WindowCloseInvite = no: ' & $currentChecksum)
   Return False
EndFunc   ;==>_WindowCloseInvite



Func _WindowNextGame()
   ;_Log('_WindowNextGame')
   If $actions[$ACTION_FOLD] Then Return ; don't swap screens on my turn!
   Local $x = $window[0]+$ini_window_next_game_x
   Local $y = $window[1]+$ini_window_next_game_y
   Local $checksums = StringSplit($ini_window_next_game_checksums, ",") ; pixel checksums
   Local $size = 2
   Local $currentChecksum = PixelChecksum($x-$size, $y-$size, $x+$size, $y+$size)
   For $i = 0 To UBound($checksums) - 1
	  Local $checksum = $checksums[$i]
	  If $currentChecksum = $checksum Then
		 _Log('_WindowNextGame = yes: ' & $currentChecksum)
		 If $paused Then Return True

		 _CardsReset()
		 _OpponentsReset()
		 _ActionsReset()
		 _GuiUpdate()

		 ;Local $date = (@YEAR & "-" & @MON & "-" & @MDAY & "-" & @HOUR & "-" & @MIN & "-" & @SEC & "-" & @MSEC)
		 ;Local $path = @ScriptDir & "\data\next"
		 ;DirCreate($path)
		 ;_ScreenCapture_Capture($path & "\" & $date & ".png", $window[0], $window[1], $window[0]+$window[2]-1, $window[1]+$window[3]-1, False)

		 MouseClick($MOUSE_CLICK_LEFT, $x, $y, 1)
		 Sleep(1500)
		 MouseMove($window[0], $window[1], 1)
		 Return True
	  EndIf
   Next
   ;_Log('_WindowNextGame = no: ' & $currentChecksum)
   Return False
EndFunc   ;==>_WindowNextGame
