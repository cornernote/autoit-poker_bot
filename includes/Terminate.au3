;=================================================================
; Terminate
;=================================================================
Func _Terminate()
   _Log('Terminating')
   _ClassifyClose()
   _GuiDelete()
   _Log('Terminated')
   Exit
EndFunc