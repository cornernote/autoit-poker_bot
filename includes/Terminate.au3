;=================================================================
; Terminate
;=================================================================
Func _Terminate()
   Local $confirm = MsgBox($MB_YESNO, "Confirm Exit" ,"Do you want to terminate the bot?")
   If $confirm <> $IDYES Then
	  Return
   EndIf
   _Log('Terminating')
   _ClassifyClose()
   _GuiDelete()
   _Log('Terminated')
   Exit
EndFunc