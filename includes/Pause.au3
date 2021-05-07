;=================================================================
; Pause Toggle
;=================================================================
Global $paused = True
Func _PauseToggle()
   If $paused == False Then
	  $paused = True
      _Log('Paused')
	  GUICtrlSetData($guiPause, 'PAUSED')
	  GUICtrlSetBkColor($guiPause, 0xFF0000)
   Else
	  $paused = False
      _Log('Running')
	  GUICtrlSetData($guiPause, 'PLAYING')
	  GUICtrlSetBkColor($guiPause, 0x008000)
   EndIf
EndFunc